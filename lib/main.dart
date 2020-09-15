import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hnapp/src/Loading_info.dart';
import 'package:hnapp/src/article.dart';
import 'package:hnapp/src/hn_bloc.dart';
import 'package:hnapp/src/prefs_bloc.dart';
import 'package:hnapp/src/widgets/headline.dart';
import 'package:hnapp/src/widgets/search.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider(
        create: (BuildContext context) {
          HackerNewsBloc();
        },
      ),
      Provider(
        create: (BuildContext context) {
          PrefsBloc();
        },
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  static const primaryColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Hacker News',
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: primaryColor,
        canvasColor: Colors.black,
        textTheme: Theme.of(context).textTheme.copyWith(
              caption: TextStyle(color: Colors.white54),
              subtitle1: TextStyle(fontFamily: 'Garamond', fontSize: 10.0),
            ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Headline(
          text: _currentIndex == 0
              ? 'Flutter HackerNews: Top'
              : 'Flutter HackerNews: New',
          index: _currentIndex,
        ),
        leading: LoadingInfo(),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final Article result = await showSearch(
                context: context,
                delegate: ArticleSearch(_currentIndex == 0
                    ? Provider.of<HackerNewsBloc>(context).topArticles
                    : Provider.of<HackerNewsBloc>(context).newArticles),
              );
              if (result != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HackerNewsWebPage(result.url),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<UnmodifiableListView<Article>>(
        stream: _currentIndex == 0
            ? Provider.of<HackerNewsBloc>(context).topArticles
            : Provider.of<HackerNewsBloc>(context).newArticles,
        initialData: UnmodifiableListView<Article>([]),
        builder: (context, snapshot) => ListView(
          key: PageStorageKey(_currentIndex),
          children: snapshot.data
              .map((a) => _Item(
                    article: a,
                    prefsBloc: Provider.of<PrefsBloc>(context),
                  ))
              .toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            title: Text('Top Stories'),
            icon: Icon(Icons.stars),
          ),
          BottomNavigationBarItem(
            title: Text('New Stories'),
            icon: Icon(Icons.new_releases),
          ),
          BottomNavigationBarItem(
            title: Text('Preferences'),
            icon: Icon(Icons.settings),
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Provider.of<HackerNewsBloc>(context)
                .storiesType
                .add(StoriesType.topStories);
          }
          /*    if (index == 1) {
            Provider.of<HackerNewsBloc>(context)
                .storiesType
                .add(StoriesType.newStories);
          } else {
            _showPrefsSheet(context, Provider.of<PrefsBloc>(context));
          }*/
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  void _showPrefsSheet(BuildContext context, PrefsBloc bloc) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Scaffold(
            body: Center(
              child: StreamBuilder<PrefsState>(
                  stream: bloc.currentPrefs,
                  builder: (context, AsyncSnapshot<PrefsState> snapshot) {
                    return snapshot.hasData
                        ? Switch(
                            value: snapshot.data.showWebView,
                            onChanged: (b) => bloc.showWebViewPref.add(b),
                          )
                        : Text('Nothing');
                  }),
            ),
          );
        });
  }
}

class _Item extends StatelessWidget {
  final Article article;
  final PrefsBloc prefsBloc;

  const _Item({
    Key key,
    @required this.article,
    @required this.prefsBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(article.title != null);
    return Padding(
      key: PageStorageKey(article.title),
      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
      child: ExpansionTile(
        title:
            Text(article.title ?? '[null]', style: TextStyle(fontSize: 24.0)),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('${article.descendants} comments'),
                    SizedBox(width: 16.0),
                    IconButton(
                      icon: Icon(Icons.launch),
                      color: Colors.green,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HackerNewsWebPage(article.url),
                        ),
                      ),
                    ),
                  ],
                ),
                StreamBuilder<PrefsState>(
                  stream: prefsBloc.currentPrefs,
                  builder: (context, snapshot) {
                    if (snapshot.data?.showWebView == true) {
                      return Container(
                        height: 200.0,
                        child: WebView(
                          initialUrl: article.url,
                          javascriptMode: JavascriptMode.unrestricted,
                          gestureRecognizers: Set()
                            ..add(Factory<VerticalDragGestureRecognizer>(
                                () => VerticalDragGestureRecognizer())),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HackerNewsWebPage extends StatelessWidget {
  HackerNewsWebPage(this.url);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web Page'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.favorite),
        onPressed: () {},
      ),
    );
  }
}
