import 'dart:convert';
import 'package:boiler_fuel/api_key.dart';
import 'package:boiler_fuel/constants.dart';
import 'package:http/http.dart' as http;

class WebAPI {
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
