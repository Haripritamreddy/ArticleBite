import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'article_details_screen.dart';
import 'summarizing_screen.dart';
import 'about.dart';

class Article {
  final int id;
  final String title;
  final String summary;
  final String url;

  Article({required this.id, required this.title, required this.summary, required this.url});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'url': url,
    };
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController urlController = TextEditingController();
  List<Article> summarizedArticles = [];
  late Database _database;

  @override
  void initState() {
    super.initState();
    _openDatabase();
  }

  Future<void> _openDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'articles.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE articles(id INTEGER PRIMARY KEY, title TEXT, summary TEXT, url TEXT)',
        );
      },
      version: 1,
    );
    _loadStoredArticles();
  }

  Future<void> _loadStoredArticles() async {
    final List<Map<String, dynamic>> maps = await _database.query('articles');
    setState(() {
      summarizedArticles = List.generate(maps.length, (i) {
        return Article(
          id: maps[i]['id'],
          title: maps[i]['title'],
          summary: maps[i]['summary'],
          url: maps[i]['url'],
        );
      });
    });
  }

  Future<void> _saveArticle(Article article) async {
    await _database.insert(
      'articles',
      article.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'ArticleBite',
          style: GoogleFonts.montserrat(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () async {
              Uri url = Uri.parse('https://www.buymeacoffee.com/haripritam');
              await launchUrl(url);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
              side: BorderSide(color: Colors.white),
              minimumSize: Size(100, 30),
            ),
            child: Text('Support'),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 100.0),
              ListTile(
                title: Text(
                  'Home',
                  style: GoogleFonts.martianMono(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26.0,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 56.0),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 20.0),
              ListTile(
                title: Text(
                  'About',
                  style: GoogleFonts.martianMono(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26.0,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 56.0),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutScreen()),
                  );
                },
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                controller: urlController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: 'Input the link here',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  String userProvidedUrl = urlController.text;
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => SummarisingScreen(articleUrl: userProvidedUrl)))
                      .then((result) {
                    if (result != null) {
                      setState(() {
                        Article newArticle = Article(
                          id: DateTime.now().millisecondsSinceEpoch,
                          title: result['title'],
                          summary: result['summary'],
                          url: result['url'],
                        );
                        summarizedArticles.insert(0, newArticle);
                        _saveArticle(newArticle);
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: Text('Summarize'),
              ),
            ),
            SizedBox(height: 50.0),
            Center(
              child: Text(
                'Summarized Bites:',
                style: GoogleFonts.montserrat(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: summarizedArticles.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ArticleDetailsScreen(
                          articleTitle: summarizedArticles[index].title,
                          articleSummary: summarizedArticles[index].summary,
                          articleUrl: summarizedArticles[index].url,
                        ),
                      ));
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16.0),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            summarizedArticles[index].title,
                            style: GoogleFonts.montserrat(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            summarizedArticles[index].summary,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            maxLines: 3, // Display only three lines
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
