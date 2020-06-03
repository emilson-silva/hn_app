import 'dart:convert' as json;

import 'package:hnapp/src/article.dart';

List<int> parseTopStories(String jsonStr) {
  final parsed = json.jsonDecode(jsonStr);
  final listOfIds = List<int>.from(parsed);
  return listOfIds;
}

Article parserArticle(String jsonStr) {
  final parsed = json.jsonDecode(jsonStr);
}
