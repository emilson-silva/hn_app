import 'package:hnapp/src/article.dart';

class HackerNewsBloc {
  Stream<List<Article>> get articles => _articlesSubject.stream;

  final _articlesSubject = BehaviorSubject<List<Article>>();
}
