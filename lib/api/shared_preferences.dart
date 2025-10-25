import 'dart:convert';

import 'package:boiler_fuel/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static String resetLocalDBKey = "RESET_LOCAL_DB_KEY";
  static String averagePromptTokensKey = "AVERAGE_PROMPT_TOKENS_KEY";
  static String averageResponseTokensKey = "AVERAGE_RESPONSE_TOKENS_KEY";
  static String totalPromptsKey = "TOTAL_PROMPTS_KEY";
  static String totalResponsesKey = "TOTAL_RESPONSES_KEY";
  static String lastGeneratedAIMealKey = "LAST_GENERATED_AI_MEAL_KEY";

  static Future<int> getResetLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(resetLocalDBKey) ?? 0;
  }

  static Future<void> incrementResetLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt(resetLocalDBKey) ?? 0;
    await prefs.setInt(resetLocalDBKey, current + 1);
  }

  static Future<void> setResetLocalData(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(resetLocalDBKey, value);
  }

  static Future<double> getAveragePromptTokens() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(averagePromptTokensKey) ?? 0.0;
  }

  static Future<double> getAverageResponseTokens() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(averageResponseTokensKey) ?? 0.0;
  }

  static Future<int> getTotalPrompts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(totalPromptsKey) ?? 0;
  }

  static Future<int> getTotalResponses() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(totalResponsesKey) ?? 0;
  }

  static Future<void> updateTokenStats(
    int promptTokens,
    int responseTokens,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    int totalPromptsCount = prefs.getInt(totalPromptsKey) ?? 0;
    int totalResponsesCount = prefs.getInt(totalResponsesKey) ?? 0;
    double averagePromptTokens = prefs.getDouble(averagePromptTokensKey) ?? 0.0;
    double averageResponseTokens =
        prefs.getDouble(averageResponseTokensKey) ?? 0.0;

    // Update totals
    totalPromptsCount += 1;
    totalResponsesCount += 1;

    // Update averages
    averagePromptTokens =
        ((averagePromptTokens * (totalPromptsCount - 1)) + promptTokens) /
        totalPromptsCount;
    averageResponseTokens =
        ((averageResponseTokens * (totalResponsesCount - 1)) + responseTokens) /
        totalResponsesCount;
    await prefs.setInt(totalPromptsKey, totalPromptsCount);
    await prefs.setInt(totalResponsesKey, totalResponsesCount);
    await prefs.setDouble(averagePromptTokensKey, averagePromptTokens);
    await prefs.setDouble(averageResponseTokensKey, averageResponseTokens);
  }

  static Future<void> setLastGeneratedAIMeal(DateTime? date) async {
    final prefs = await SharedPreferences.getInstance();
    if (date == null) {
      await prefs.remove(lastGeneratedAIMealKey);
      return;
    }
    await prefs.setString(lastGeneratedAIMealKey, date.toIso8601String());
  }

  static Future<DateTime?> getLastGeneratedAIMeal() async {
    final prefs = await SharedPreferences.getInstance();
    String? dateString = prefs.getString(lastGeneratedAIMealKey);
    if (dateString != null) {
      return DateTime.parse(dateString);
    }
    return null;
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
