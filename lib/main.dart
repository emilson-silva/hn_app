import 'package:flutter/material.dart';
import 'package:hnapp/src/article.dart';
import 'package:url_launcher/url_launcher.dart';

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
  List<Article> _articles = articles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: _articles.map(_buildItem).toList(),
      ),
    );
  }

  Widget _buildItem(Article article) {
    return Padding(
      padding:  EdgeInsets.all(16.0),
      child: ListTile(
        title: Text(
          article.text,
          style: TextStyle(fontSize: 24.0),
        ),subtitle: Text('${article.commentsCount} comments'),
        onTap: () async{
          final fakeUrl = 'http://${article.domain}';
          if( await canLaunch(fakeUrl)){
            launch(fakeUrl);
          }
        },
      ),
    );
  }
}
