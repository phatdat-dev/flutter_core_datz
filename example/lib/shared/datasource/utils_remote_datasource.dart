// ignore_for_file: depend_on_referenced_packages

import 'dart:ui';

import 'package:chatview/chatview.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:html/parser.dart' show parse;

import '../../app/api_url.dart';
import '../../core/base_datasource.dart';

class UltilRemoteDatasource extends BaseRemoteDataSource {
  // final _model = GenerativeModel(
  //   model: 'gemini-1.5-flash-latest',
  //   apiKey: AppENV.KEY_GoogleGenerativeAI,
  // );
  // Future<String?> _generateContentWithGemini(String prompt) async => (await _model.generateContent([Content.text(prompt)])).text;

  FutureEitherAppException<String?> generateContent(
    String prompt, {
    bool useGemini = false,
    List<Message> messages = const [],
  }) async {
    final result = AppException().handleExceptionAsync(() async {
      // if (useGemini) return _generateContentWithGemini(prompt);
      final response = await apiCall.onRequest(
        ApiUrl.POST_OdooGPTChat(),
        RequestMethod.POST,
        isShowLoading: false,
        body: {
          "jsonrpc": "2.0",
          "method": "call",
          "params": {
            "prompt": prompt,
            "conversation_history": messages
                .map(
                  (e) => {
                    "role": e.sentBy == "1" ? "user" : "assistant",
                    "content": e.message,
                  },
                )
                .toList(),
            "database_id": "b172e8aa-591c-11ef-8bf0-04bf1bad20dd",
          },
          "id": "432e6ccd5acb4b5895ae27f88df32f85", // uuid.v4().hex
        },
      );
      return response["result"]["content"] as String?;
    }, showToastError: false);
    return result;
  }

  Future<String?> translateText(String text, Locale locale) async {
    final result = await generateContent(
      "Translate the following text to languageCode('${locale.toLanguageTag()}') and return the result in a JSON object with the key 'text': $text",
    );
    return result.toRight();
  }

  FutureEitherAppException<List<String>?> getImageFromGoogle(
    String prompt, {
    int take = 10,
  }) async {
    // prompt = "imageSize 500x500: $prompt";
    final result = AppException().handleExceptionAsync(() async {
      final response = await apiCall.onRequest(
        // "https://www.google.com/search?q=$prompt&udm=2",
        "https://www.pexels.com/search/$prompt",
        RequestMethod.GET,
        isShowLoading: false,
      );
      final doc = parse(response);
      final images = doc
          .querySelectorAll("img")
          .take(take)
          .map((e) => e.attributes["src"]!)
          .where((e) => e.contains('http'))
          .toList();
      return images;
    }, showToastError: false);
    return result;
  }
}
