import 'dart:async';
import 'dart:collection';

import 'package:hnapp/src/article.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class HackerNewsBloc {
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

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  final _isLoadingSubject = BehaviorSubject<bool>();

  final _articlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();

  var _articles = <Article>[];

  final _storiesTypeController = StreamController<StoriesType>();

  HackerNewsBloc() {
    _initializeArticle();

    _storiesTypeController.stream.listen((storiesType) async {
      _getArticlesAndUpdate(await _getIds(storiesType));
    });
  }

  Future<void> _initializeArticle() async {
    _getArticlesAndUpdate(await _getIds(StoriesType.topStories));
  }

  Stream<UnmodifiableListView<Article>> get articles => _articlesSubject.stream;

  Sink<StoriesType> get storiesType => _storiesTypeController.sink;

  void close() {
    _storiesTypeController.close();
  }

  Future<List<int>> _getIds(StoriesType type) async {
    final partUrl = type == StoriesType.topStories ? 'top' : 'new';
    final url = '$_baseUrl${partUrl}stories.json';
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw HackerNewsApiError("Stories $type couldn't be fetched.");
    }
    return parseTopStories(response.body).take(10).toList();
  }

  static const _baseUrl = 'https://hacker-news.firebaseio.com/v0/';

  Future<Article> _getArticle(int id) async {
    final storyUrl = '${_baseUrl}item/$id.json';
    final storyRes = await http.get(storyUrl);
    if (storyRes.statusCode == 200) {
      return parseArticle(storyRes.body);
    }
    throw HackerNewsApiError("Article $id couldn't be fetched");
  }

  _getArticlesAndUpdate(List<int> ids) async {
    _isLoadingSubject.add(true);
    await _updateArticles(ids);
    await Future.delayed(Duration(seconds: 3));
    _articlesSubject.add(UnmodifiableListView(_articles));
    _isLoadingSubject.add(false);
  }

  Future<Null> _updateArticles(List<int> articleIds) async {
    final futureArticles = articleIds.map((id) => _getArticle(id));
    final articles = await Future.wait(futureArticles);
    _articles = articles;
  }
}

enum StoriesType {
  topStories,
  newStories,
}

class HackerNewsApiError extends Error {
  HackerNewsApiError(this.message);

  final String message;
}
