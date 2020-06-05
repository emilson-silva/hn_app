import 'dart:convert' as json;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'article.g.dart';

abstract class Article implements Built<Article, ArticleBuilder> {
  static Serializer<Article> get serializer => _$articleSerializer;

  int get id;

  @nullable
  bool get deleted;

  String get type; //"j// ob", "story", "comment", "poll", or "pollopt".

  String get by;

  int get time;

  @nullable
  String get text;

  @nullable
  bool get dead;

  @nullable
  int get parent;

  @nullable
  int get poll;

  BuiltList<int> get kids;

  @nullable
  String get url;

  @nullable
  int get score;

  @nullable
  String get title;

  BuiltList<int> get parts;

  @nullable
  int get descendants;

  Article._();
  factory Article([updates(ArticleBuilder b)]) = _$Article;
}

List<int> parseTopStories(String jsonStr) {
  return [];
  final parsed = json.jsonDecode(jsonStr);
  final listOfIds = List<int>.from(parsed);
  return listOfIds;
}

Article parseArticle(String jsonStr) {
  final parsed = json.jsonDecode(jsonStr);
  Article article =
      standardSerializers.deserializeWith(Article.serializer, parsed);
  return article;
}
//
//
//class Article {
//  final String text;
//  final String url;
//  final String by;
//  final String age;
//  final int score;
//  final int commentsCount;
//
//  const Article(
//      {this.age, this.url, this.by, this.commentsCount, this.score, this.text});
//}
//
//final articles = [
//  new Article(
//    text:
//        'Ministro pede à PF investigação sobre vazamento de supostos dados de Bolsonaro e filhos',
//    url: 'g1.globo.com',
//    by: 'globo',
//    age: '3 hours',
//    score: 287,
//    commentsCount: 128,
//  ),
//  new Article(
//    text:
//        'Circular Shock Acoustic Waves in Ionosphere triggered by Launch of Formosat - 5',
//    url: 'wiley.com',
//    by: 'zdw',
//    age: '3 hours',
//    score: 177,
//    commentsCount: 62,
//  ),
//  new Article(
//    text: 'The Boring Flutter Development Show [Pilot Episode]',
//    url: 'www.youtube.com',
//    by: 'zdw',
//    age: '3 hours',
//    score: 177,
//    commentsCount: 62,
//  ),
//  new Article(
//    text: 'BMW says electric car mass production not viable until 2020',
//    url: 'reuters.com',
//    by: 'Mononokay',
//    age: '2 hours',
//    score: 81,
//    commentsCount: 128,
//  ),
//  new Article(
//    text: 'BMW says electric car mass production not viable until 2020',
//    url: 'reuters.com',
//    by: 'Mononokay',
//    age: '2 hours',
//    score: 81,
//    commentsCount: 128,
//  ),
//  new Article(
//    text: 'Evolution Is the New Deep Learning',
//    url: 'sentient.ai',
//    by: 'jonbaer',
//    age: '4 hours',
//    score: 200,
//    commentsCount: 87,
//  ),
//  new Article(
//    text: 'TCP Tracepoints have arrived in Linux',
//    url: 'brendangregg.com',
//    by: 'brendangregg',
//    age: '1 hours',
//    score: 35,
//    commentsCount: 0,
//  ),
//  new Article(
//    text:
//        'Section 230: A Key Legal Shield for Facebook, Google Is about to Change,',
//    url: 'github.com',
//    by: 'bluzi',
//    age: '8 hours',
//    score: 37,
//    commentsCount: 26,
//  ),
//  new Article(
//    text: 'A Visiting Star jostled our solar System 70,000 Years Ago,',
//    url: 'gizmodo.com',
//    by: 'rbanffy',
//    age: '7 hours',
//    score: 42,
//    commentsCount: 18,
//  ),
//  new Article(
//    text: 'Using technical Debt in Your Favor',
//    url: 'gitconnected.com',
//    by: 'treyhuffine',
//    age: '7 hours',
//    score: 140,
//    commentsCount: 123,
//  ),
//  new Article(
//    text:
//        'Circular Shock Acoustic Waves in Ionosphere triggered by Launch of Formosat - 5',
//    url: 'wiley.com',
//    by: 'zdw',
//    age: '3 hours',
//    score: 177,
//    commentsCount: 62,
//  ),
//  new Article(
//    text: 'BMW says electric car mass production not viable until 2020',
//    url: 'reuters.com',
//    by: 'Mononokay',
//    age: '2 hours',
//    score: 81,
//    commentsCount: 128,
//  ),
//  new Article(
//    text: 'BMW says electric car mass production not viable until 2020',
//    url: 'reuters.com',
//    by: 'Mononokay',
//    age: '2 hours',
//    score: 81,
//    commentsCount: 128,
//  ),
//  new Article(
//    text: 'Evolution Is the New Deep Learning',
//    url: 'sentient.ai',
//    by: 'jonbaer',
//    age: '4 hours',
//    score: 200,
//    commentsCount: 87,
//  ),
//  new Article(
//    text: 'TCP Tracepoints have arrived in Linux',
//    url: 'brendangregg.com',
//    by: 'brendangregg',
//    age: '1 hours',
//    score: 35,
//    commentsCount: 0,
//  ),
//  new Article(
//    text:
//        'Section 230: A Key Legal Shield for Facebook, Google Is about to Change,',
//    url: 'github.com',
//    by: 'bluzi',
//    age: '8 hours',
//    score: 37,
//    commentsCount: 26,
//  ),
//  new Article(
//    text: 'A Visiting Star jostled our solar System 70,000 Years Ago,',
//    url: 'gizmodo.com',
//    by: 'rbanffy',
//    age: '7 hours',
//    score: 42,
//    commentsCount: 18,
//  ),
//  new Article(
//    text: 'Using technical Debt in Your Favor',
//    url: 'gitconnected.com',
//    by: 'treyhuffine',
//    age: '7 hours',
//    score: 140,
//    commentsCount: 123,
//  ),
//  new Article(
//    text:
//        'Circular Shock Acoustic Waves in Ionosphere triggered by Launch of Formosat - 5',
//    url: 'wiley.com',
//    by: 'zdw',
//    age: '3 hours',
//    score: 177,
//    commentsCount: 62,
//  ),
//  new Article(
//    text: 'BMW says electric car mass production not viable until 2020',
//    url: 'reuters.com',
//    by: 'Mononokay',
//    age: '2 hours',
//    score: 81,
//    commentsCount: 128,
//  ),
//  new Article(
//    text: 'BMW says electric car mass production not viable until 2020',
//    url: 'reuters.com',
//    by: 'Mononokay',
//    age: '2 hours',
//    score: 81,
//    commentsCount: 128,
//  ),
//  new Article(
//    text: 'Evolution Is the New Deep Learning',
//    url: 'sentient.ai',
//    by: 'jonbaer',
//    age: '4 hours',
//    score: 200,
//    commentsCount: 87,
//  ),
//  new Article(
//    text: 'TCP Tracepoints have arrived in Linux',
//    url: 'brendangregg.com',
//    by: 'brendangregg',
//    age: '1 hours',
//    score: 35,
//    commentsCount: 0,
//  ),
//  new Article(
//    text:
//        'Section 230: A Key Legal Shield for Facebook, Google Is about to Change,',
//    url: 'github.com',
//    by: 'bluzi',
//    age: '8 hours',
//    score: 37,
//    commentsCount: 26,
//  ),
//  new Article(
//    text: 'A Visiting Star jostled our solar System 70,000 Years Ago,',
//    url: 'gizmodo.com',
//    by: 'rbanffy',
//    age: '7 hours',
//    score: 42,
//    commentsCount: 18,
//  ),
//  new Article(
//    text: 'Using technical Debt in Your Favor',
//    url: 'gitconnected.com',
//    by: 'treyhuffine',
//    age: '7 hours',
//    score: 140,
//    commentsCount: 123,
//  ),
//];
