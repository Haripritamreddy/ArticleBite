import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class SummarisingScreen extends StatefulWidget {
  final String articleUrl;

  SummarisingScreen({required this.articleUrl});

  @override
  _SummarisingScreenState createState() => _SummarisingScreenState();
}

class _SummarisingScreenState extends State<SummarisingScreen> {
  String title = '';
  String summarizedArticle = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTitleAndSummarize();
  }

  Future<String> getContentFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get content from URL: $url');
    }
  }

  Future<void> fetchTitleAndSummarize() async {
    try {
      final content = await getContentFromUrl(widget.articleUrl);
      final document = html.parse(content);
      final elements = document.querySelectorAll('h1, h2, p');

      String articleText = '';
      for (final element in elements) {
        articleText += element.text + '\n';
      }


      String apiKey = 'YOUR-API-KEY-HERE';
      String model = 'gpt-3.5-turbo-0613';


      String titleEndpoint = 'https://api.naga.ac/v1/chat/completions';
      String summaryEndpoint = 'https://api.naga.ac/v1/chat/completions';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };

      Map<String, dynamic> titlePayload = {
        'model': model,
        'messages': [
          {'role': 'system', 'content': 'You are a helpful assistant.'},
          {
            'role': 'user',
            'content': 'Get the title for the article at:\n${widget.articleUrl}',
          },
        ],
      };

      Map<String, dynamic> summaryPayload = {
        'model': model,
        'messages': [
          {'role': 'system', 'content': 'You are a helpful assistant.'},
          {
            'role': 'user',
            'content': 'Summarize the following article:\n$articleText',
          },
        ],
      };


      http.Response titleResponse = await http.post(
        Uri.parse(titleEndpoint),
        headers: headers,
        body: jsonEncode(titlePayload),
      );


      Map<String, dynamic> titleData = jsonDecode(titleResponse.body);
      String fetchedTitle = titleData['choices'][0]['message']['content'];


      http.Response summaryResponse = await http.post(
        Uri.parse(summaryEndpoint),
        headers: headers,
        body: jsonEncode(summaryPayload),
      );


      Map<String, dynamic> summaryData = jsonDecode(summaryResponse.body);
      String summary = summaryData['choices'][0]['message']['content'];

      setState(() {
        isLoading = false;
        title = fetchedTitle;
        summarizedArticle = summary;
      });


      Navigator.pop(context, {
        'title': title,
        'summary': summarizedArticle,
        'url': widget.articleUrl,
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        title = 'Failed to fetch title';
        summarizedArticle = 'Failed to fetch and summarize the article: $e';
      });
      print('Error fetching title and summarizing article: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summarising...'),
        backgroundColor: Colors.black,
        actions: <Widget>[
          ElevatedButton(
            onPressed: () async {
              // Use the launchUrl function to open a web page
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
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: title,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                summarizedArticle,
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
                      color: Colors.white, // White text
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  Uri url = Uri.parse(widget.articleUrl);
                  await launchUrl(url);
                },
                child: Text(
                  widget.articleUrl,
                  style: TextStyle(
                    fontSize: 16.0,
                    color:
                    Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
