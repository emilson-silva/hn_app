import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hnapp/src/article.dart';
import 'package:hnapp/src/hn_bloc.dart';
import 'package:hnapp/src/prefs_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  final hnBloc = HackerNewsBloc();
  final prefsBloc = PrefsBloc();

  runApp(MyApp(
    hackerNewsBloc: hnBloc,
    prefsBloc: prefsBloc,
  ));
  //TODO
}

class MyApp extends StatelessWidget {
  final HackerNewsBloc hackerNewsBloc;
  final PrefsBloc prefsBloc;

  MyApp({
    Key key,
    this.hackerNewsBloc,
    this.prefsBloc,
  }) : super(key: key);

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
      home: MyHomePage(
        title: 'Flutter Hacker News',
        hackerNewsBloc: hackerNewsBloc,
        prefsBloc: prefsBloc,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final HackerNewsBloc hackerNewsBloc;
  final PrefsBloc prefsBloc;
  final String title;

  MyHomePage({Key key, this.title, this.hackerNewsBloc, this.prefsBloc})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: LoadingInfo(widget.hackerNewsBloc.isLoading),
        elevation: 0.0,
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                final Article result = await showSearch(
                  context: context,
                  delegate: ArticleSearch(_currentIndex == 0
                      ? widget.hackerNewsBloc.topArticles
                      : widget.hackerNewsBloc.newArticles),
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
          ),
        ],
      ),
      body: _currentIndex == 0
          ? StreamBuilder<UnmodifiableListView<Article>>(
              stream: widget.hackerNewsBloc.topArticles,
              initialData: UnmodifiableListView<Article>([]),
              builder: (context, snapshot) => ListView(
                key: PageStorageKey(0),
                children: snapshot.data.map(_buildItem).toList(),
              ),
            )
          : StreamBuilder<UnmodifiableListView<Article>>(
              stream: widget.hackerNewsBloc.newArticles,
              initialData: UnmodifiableListView<Article>([]),
              builder: (context, snapshot) => ListView(
                key: PageStorageKey(1),
                children: snapshot.data.map(_buildItem).toList(),
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
            widget.hackerNewsBloc.storiesType.add(StoriesType.topStories);
          }
          if (index == 1) {
            widget.hackerNewsBloc.storiesType.add(StoriesType.newStories);
          } else {
            _showPrefsSheet(context, widget.prefsBloc);
          }
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

  Widget _buildItem(Article article) {
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
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HackerNewsWebPage(article.url),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                StreamBuilder<PrefsState>(
                  stream: widget.prefsBloc.currentPrefs,
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

class LoadingInfo extends StatefulWidget {
  LoadingInfo(this._isLoading);

  final Stream<bool> _isLoading;

  @override
  LoadingInfoState createState() => LoadingInfoState();
}

class LoadingInfoState extends State<LoadingInfo>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget._isLoading,
      builder: (BuildContext context, AsyncSnapshot<bool> loading) {
        if (loading.hasData && loading.data) {
          _controller.forward().then((e) {
            _controller.reverse();
          });
          return FadeTransition(
            child: Icon(FontAwesomeIcons.hackerNewsSquare),
            opacity: Tween(begin: .5, end: 1.0).animate(
              CurvedAnimation(
                curve: Curves.easeIn,
                parent: _controller,
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}

class ArticleSearch extends SearchDelegate<Article> {
  ArticleSearch(this.articles);

  final Stream<UnmodifiableListView<Article>> articles;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<UnmodifiableListView<Article>>(
      stream: articles,
      builder:
          (context, AsyncSnapshot<UnmodifiableListView<Article>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text('No data!'),
          );
        }

        final results = snapshot.data.where(
          (a) => a.title.toLowerCase().contains(query),
        );

        return ListView(
          children: results
              .map<ListTile>((a) => ListTile(
                    title: Text(a.title,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontSize: 16.0)),
                    leading: Icon(Icons.book),
                    onTap: () async {
                      if (await canLaunch(a.url)) {
                        await launch(a.url);
                      }
                      close(context, a);
                    },
                  ))
              .toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<UnmodifiableListView<Article>>(
      stream: articles,
      builder:
          (context, AsyncSnapshot<UnmodifiableListView<Article>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text('No data!'),
          );
        }

        final results = snapshot.data.where(
          (a) => a.title.toLowerCase().contains(query),
        );

        return ListView(
          children: results
              .map<ListTile>((a) => ListTile(
                    title: Text(a.title,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontSize: 16.0, color: Colors.blue)),
                    onTap: () {
                      close(context, a);
                    },
                  ))
              .toList(),
        );
      },
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
