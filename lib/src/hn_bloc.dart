import 'dart:async';
import 'dart:collection';

import 'package:hnapp/src/article.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

enum StoriesType {
  topStories,
  newStories,
}

class HackerNewsBloc {
  final _articlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();

  var _articles = <Article>[];

  Sink<StoriesType> get storiesType => _storiesTypeController.sink;

  final _storiesTypeController = StreamController<StoriesType>();

  static List<int> _newIds = [
    23429273,
    23430861,
    23426752,
    23429959,
    23427689,
    23414872,
    23430575,
    23415034,
    23428547,
    23427186,
    23428432,
    23415175,
    23426154,
    23415682,
    23418699,
  ];

  static List<int> _topIds = [
    23430282,
    23430332,
    23428398,
    23431150,
    23430671,
    23425041,
    23422475,
    23425508,
    23426189,
    23430880,
    23425524,
    23429855,
    23426538,
    23430142,
    23414793,
    23415668,
  ];

  HackerNewsBloc() {
    _getArticlesAndUpdate(_topIds);

    _storiesTypeController.stream.listen((storiesType) {
      List<int> ids;
      if (storiesType == StoriesType.newStories) {
        _getArticlesAndUpdate(_newIds);
      } else {
        _getArticlesAndUpdate(_topIds);
      }
    });
  }

  _getArticlesAndUpdate(List<int> ids) {
    _updateArticles(ids)
        .then((_) => _articlesSubject.add(UnmodifiableListView(_articles)));
  }

  Stream<UnmodifiableListView<Article>> get articles => _articlesSubject.stream;

  Future<Article> _getArticle(int id) async {
    final storyUrl = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
    final storyRes = await http.get(storyUrl);
    if (storyRes.statusCode == 200) {
      return parseArticle(storyRes.body);
    }
  }

  Future<Null> _updateArticles(List<int> articleIds) async {
    final futureArticles = articleIds.map((id) => _getArticle(id));
    final articles = await Future.wait(futureArticles);
    _articles = articles;
  }
}
