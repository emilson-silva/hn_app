import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hnapp/src/article.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> _ids = [
    9224,
    8917,
    8952,
    8884,
    8887,
    8869,
    8958,
    8940,
    8908,
    9005,
    8873,
    9671,
    9067,
    9055,
    8865,
    8881,
    8872,
    8955,
    10403,
    8903,
    8928,
    9125,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 3));
          setState(() {
            _articles.removeAt(0);
          });
        },
        child: ListView(
          children: _articles.map(_buildItem).toList(),
        ),
      ),
    );
  }

  Widget _buildItem(Article article) {
    return Padding(
      key: Key(article.text),
      padding: EdgeInsets.all(16.0),
      child: ExpansionTile(
        title: Text(article.text, style: TextStyle(fontSize: 24.0)),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Text('${article.commentsCount} comments'),
              IconButton(
                icon: Icon(Icons.launch),
                color: Colors.green,
                onPressed: () async {
                  /* final fakeUrl = 'http://${article.url}';
                  if (await canLaunch(fakeUrl)) {
                    launch(fakeUrl);
                  }*/
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
