import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';


class ArticleDetailsScreen extends StatelessWidget {
  final String articleTitle;
  final String articleSummary;
  final String articleUrl;

  ArticleDetailsScreen({
    required this.articleTitle,
    required this.articleSummary,
    required this.articleUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article Details'),
        backgroundColor: Colors.black,
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
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              articleTitle,
              style: GoogleFonts.montserrat(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              articleSummary,
              style: GoogleFonts.montserrat(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Original Article URL:',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                Uri url = Uri.parse(articleUrl);
                await launchUrl(url);
              },
              child: Text(
                articleUrl,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
