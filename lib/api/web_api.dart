import 'dart:convert';
import 'package:boiler_fuel/api_key.dart';
import 'package:boiler_fuel/constants.dart';
import 'package:flutter/services.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';

class WebAPI {
  /// Loads all .txt and .pdf files from assets/rag-docs as context strings
  Future<List<String>> loadRAGDocuments() async {
    final contexts = <String>[];

    // List of document files in assets/rag-docs
    final textFiles = [
      'carbs.txt',
      'fats.txt',
      'healthy-plate.txt',
      'protein.txt',
    ];

    final pdfFiles = ['hypertrophy.pdf', 'muscle-growth.pdf'];

    // Load all text files
    for (final file in textFiles) {
      try {
        final content = await rootBundle.loadString('assets/rag-docs/$file');
        contexts.add(content);
      } catch (e) {
        print('Warning: Could not load $file: $e');
      }
    }

    // Load and parse all PDF files
    for (final file in pdfFiles) {
      try {
        final bytes = await rootBundle.load('assets/rag-docs/$file');
        final document = PdfDocument(inputBytes: bytes.buffer.asUint8List());
        final textExtractor = PdfTextExtractor(document);
        final text = textExtractor.extractText();
        document.dispose();

        if (text.isNotEmpty) {
          contexts.add(text);
        }
      } catch (e) {
        print('Warning: Could not load PDF $file: $e');
      }
    }

    return contexts;
  }

  Future<Food?> fetchFoodResponse(String itemId) async {
    final url = Uri.parse('https://api.hfs.purdue.edu/menus/v3/GraphQL');

    final body = jsonEncode({
      "variables": {"id": itemId},
      "query": """
      query (\$id: Guid!) {
        itemByItemId(itemId: \$id) {
          itemId
          name
          ingredients
          isNutritionReady
          nutritionFacts {
            dailyValueLabel
            label
            name
            value
            __typename
          }
          traits {
            svgIcon
            svgIconWithoutBackground
            name
            type
            __typename
          }
          appearances {
            date
            locationName
            stationName
            mealName
            __typename
          }
          components {
            itemId
            name
            isFlaggedForCurrentUser
            isHiddenForCurrentUser
            isNutritionReady
            traits {
              svgIcon
              svgIconWithoutBackground
              name
              type
              __typename
            }
            __typename
          }
          __typename
        }
      }
    """,
    });

    try {
      final response = await http
          .post(
            url,
            headers: {
              'User-Agent': 'BoilerFuel-Backend/1.0',
              'Content-Type': 'application/json',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 50));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final itemData = data['data']['itemByItemId'];
        if (itemData != null) {
          return Food.fromGraphQL(itemData);
        }
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Request failed: $e");
    }
  }

  Future<String> getGeminiRAGResponse(
    String model,
    String prompt,
    List<String> contexts,
  ) async {
    // Load service account credentials
    final serviceAccountJson = await rootBundle.loadString(
      'assets/UPlateServiceWorker.json',
    );
    final serviceAccountData = jsonDecode(serviceAccountJson);

    // Get OAuth2 access token
    final tokenUrl = Uri.parse('https://oauth2.googleapis.com/token');
    final tokenResponse = await http.post(
      tokenUrl,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        'assertion': _createJWT(serviceAccountData),
      },
    );

    if (tokenResponse.statusCode != 200) {
      throw Exception("Failed to get access token: ${tokenResponse.body}");
    }

    final accessToken = jsonDecode(tokenResponse.body)['access_token'];

    // Select most relevant context chunks to keep prompt size manageable
    final relevantContext = _selectRelevantContext(prompt, contexts);

    // Build the context-enhanced prompt
    final enhancedPrompt =
        '''
Context information:
$relevantContext

Based on the context above, please answer the following question:
$prompt

If the answer cannot be found in the context, please say so.
''';

    // Call Vertex AI Gemini API
    final project = 'purdue-gdg-rag';
    final location = 'us-central1';
    final modelName = model.isEmpty ? 'gemini-1.5-flash-002' : model;

    final vertexUrl = Uri.parse(
      'https://$location-aiplatform.googleapis.com/v1/projects/$project/locations/$location/publishers/google/models/$modelName:generateContent',
    );

    final requestBody = jsonEncode({
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": enhancedPrompt},
          ],
        },
      ],
      "generationConfig": {
        "temperature": 0.7,
        "topP": 0.95,
        "topK": 40,
        "maxOutputTokens": 8192,
      },
    });

    final response = await http.post(
      vertexUrl,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['candidates'][0]['content']['parts'][0]['text'];
    } else {
      throw Exception(
        "Vertex AI Error: ${response.statusCode} - ${response.body}",
      );
    }
  }

  /// Prepares comprehensive context for meal generation
  /// Uses intelligent summarization to fit within token limits while preserving key nutrition info
  String _selectRelevantContext(String prompt, List<String> contexts) {
    // Gemini 1.5 Flash has 1M token context window, but we'll use ~100K tokens (~400K chars)
    // for comprehensive nutrition context while leaving room for response
    const maxChars = 400000; // Approximately 100,000 tokens

    final contextBuffer = StringBuffer();
    var totalChars = 0;

    // Include all contexts for meal generation, but smartly truncate if needed
    for (var i = 0; i < contexts.length; i++) {
      final context = contexts[i];

      // Add document separator for clarity
      if (i > 0) {
        contextBuffer.write('\n\n--- Document ${i + 1} ---\n\n');
      }

      // Check if adding this entire document would exceed limit
      if (totalChars + context.length <= maxChars) {
        // Include full document
        contextBuffer.write(context);
        totalChars += context.length;
      } else {
        // Prioritize key sections and summaries
        final remainingSpace = maxChars - totalChars;
        if (remainingSpace > 500) {
          // Extract key sections (look for headers, lists, important paragraphs)
          final keyContent = _extractKeyContent(context, remainingSpace);
          contextBuffer.write(keyContent);
          totalChars += keyContent.length;
        }
        break; // Stop adding more documents if we're at limit
      }
    }

    return contextBuffer.toString();
  }

  /// Extracts the most important content from a document when space is limited
  String _extractKeyContent(String text, int maxLength) {
    final lines = text.split('\n');
    final importantLines = <String>[];
    var currentLength = 0;

    // Priority 1: Lines with headers or key terms
    final keyPatterns = [
      RegExp(r'^#+\s+', multiLine: true), // Markdown headers
      RegExp(
        r'(protein|carb|fat|calorie|nutrient|vitamin|mineral)',
        caseSensitive: false,
      ),
      RegExp(
        r'(recommended|should|must|important|key|essential)',
        caseSensitive: false,
      ),
      RegExp(r'^\s*[\d\-\*•]\s+', multiLine: true), // Lists
    ];

    for (final line in lines) {
      if (currentLength >= maxLength) break;

      // Check if line matches any key pattern
      final isImportant = keyPatterns.any((pattern) => pattern.hasMatch(line));

      if (isImportant || line.trim().isEmpty) {
        if (currentLength + line.length + 1 <= maxLength) {
          importantLines.add(line);
          currentLength += line.length + 1; // +1 for newline
        }
      }
    }

    // If we have room and didn't get much content, add first paragraphs
    if (importantLines.length < 5 && currentLength < maxLength / 2) {
      for (final line in lines) {
        if (currentLength >= maxLength) break;
        if (!importantLines.contains(line)) {
          if (currentLength + line.length + 1 <= maxLength) {
            importantLines.add(line);
            currentLength += line.length + 1;
          }
        }
      }
    }

    return importantLines.join('\n');
  }

  String _createJWT(Map<String, dynamic> serviceAccount) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final jwt = JWT({
      'iss': serviceAccount['client_email'],
      'sub': serviceAccount['client_email'],
      'aud': 'https://oauth2.googleapis.com/token',
      'iat': now,
      'exp': now + 3600,
      'scope': 'https://www.googleapis.com/auth/cloud-platform',
    });

    // Sign the JWT with the service account's private key
    final privateKey = serviceAccount['private_key'] as String;
    final token = jwt.sign(
      RSAPrivateKey(privateKey),
      algorithm: JWTAlgorithm.RS256,
    );

    return token;
  }

  Future<String> getGeminiResponse(String model, String prompt) async {
    String baseUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=';
    final uri = Uri.parse('$baseUrl${ApiKeys.geminiApiKey}');
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt},
          ],
        },
      ],
    });
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['candidates'][0]['content']['parts'][0]['text'];
    } else {
      throw Exception("Gemini API Error: ${response.body}");
    }
  }
}
