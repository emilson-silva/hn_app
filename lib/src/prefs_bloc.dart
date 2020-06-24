import 'dart:async';
import 'dart:collection';

import 'package:hnapp/src/article.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class PrefsBloc {
  Stream<bool> get isLoading => _isLoadingSubject.stream;

  final _isLoadingSubject = BehaviorSubject<bool>();

  final _topArticlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();

  final _newArticlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();

  var _articles = <Article>[];

  final _storiesTypeController = StreamController<StoriesType>();

  PrefsBloc() {
    _cacheArticles = HashMap<int, Article>();
    _initializeArticles();

    _storiesTypeController.stream.listen((storiesType) async {
      _getArticlesAndUpdate(
          _newArticlesSubject, await _getIds(StoriesType.newStories));
      _getArticlesAndUpdate(
          _topArticlesSubject, await _getIds(StoriesType.newStories));
    });
  }

  Stream<UnmodifiableListView<Article>> get topArticles =>
      _topArticlesSubject.stream;
  Stream<UnmodifiableListView<Article>> get newArticles =>
      _newArticlesSubject.stream;

  Sink<StoriesType> get storiesType => _storiesTypeController.sink;

  Future<void> _initializeArticles() async {
    _getArticlesAndUpdate(
        _newArticlesSubject, await _getIds(StoriesType.topStories));

    _getArticlesAndUpdate(
        _topArticlesSubject, await _getIds(StoriesType.topStories));
  }

  void close() {
    _storiesTypeController.close();
  }

  Future<List<int>> _getIds(StoriesType type) async {
    final partUrl = type == StoriesType.topStories ? 'top' : 'new';
    final url = '$_baseUrl${partUrl}stories.json';
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw PrefsBlocError("Stories $type couldn't be fetched.");
    }
    return parseTopStories(response.body).take(10).toList();
  }

  HashMap<int, Article> _cacheArticles;

  static const _baseUrl = 'https://hacker-news.firebaseio.com/v0/';

  Future<Article> _getArticle(int id) async {
    if (!_cacheArticles.containsKey(id)) {
      final storyUrl = '${_baseUrl}item/$id.json';
      final storyRes = await http.get(storyUrl);
      if (storyRes.statusCode == 200) {
        _cacheArticles[id] = parseArticle(storyRes.body);
      } else {
        throw PrefsBlocError("Article $id couldn't be fetched");
      }
    }
    return _cacheArticles[id];
  }

  _getArticlesAndUpdate(BehaviorSubject<UnmodifiableListView<Article>> subject,
      List<int> ids) async {
    _isLoadingSubject.add(true);
    await _updateArticles(ids);
    await Future.delayed(Duration(seconds: 3));
    subject.add(UnmodifiableListView(_articles));
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

class PrefsBlocError extends Error {
  final String message;

  PrefsBlocError(this.message);
}

//static List<int> _newIds = [
//  23429273,
//  23430861,
//  23426752,
//  23429959,
//  23427689,
//  23414872,
//  23430575,
//  23415034,
//  23428547,
//  23427186,
//  23428432,
//  23415175,
//  23426154,
//  23415682,
//  23418699,
//];
//
//static List<int> _topIds = [
//  23430282,
//  23430332,
//  23428398,
//  23431150,
//  23430671,
//  23425041,
//  23422475,
//  23425508,
//  23426189,
//  23430880,
//  23425524,
//  23429855,
//  23426538,
//  23430142,
//  23414793,
//  23415668,
//];
