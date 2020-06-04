import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'json_parsing.g.dart';

abstract class Article implements Built<Article, ArticleBuilder> {
  int get id;

  bool get deleted;
  String get type;	 //"job", "story", "comment", "poll", or "pollopt".
  String get by;
  int get time;
  String get text;
  bool get dead;
  int get parent;
  int get poll;
  BuiltList<int> kids;
  url
  score
  title
  parts
  descendants

  Article._();
  factory Article([updates(ArticleBuilder b)]) = _$Article;
}

List<int> parseTopStories(String jsonStr) {
  return [];
/*  final parsed = json.jsonDecode(jsonStr);
  final listOfIds = List<int>.from(parsed);
  return listOfIds;*/
}

Article parseArticle(String jsonStr) {
  return null;
  /* final parsed = json.jsonDecode(jsonStr);
  Article article = Article.fromJson(parsed);
  return article;*/
}
