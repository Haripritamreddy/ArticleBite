import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Me',
          style: GoogleFonts.raleway(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          SizedBox(height: 20.0),
          Center(
            child: CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
          ),
          SizedBox(height: 20.0),
          Center(
            child: Text(
              'Hari Pritam Reddy Alapati',
              style: GoogleFonts.montserrat(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Center(
            child: Text(
              'Here are all my social links if you want to talk to me. Any support through donations helps run the app longer.',
              style: GoogleFonts.mukta(
                fontSize: 16.0,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 30.0),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Image.asset(
                    'assets/linkedin.png',
                    width: 32.0,
                    height: 32.0,
                  ),
                  onTap: () async {
                    Uri url = Uri.parse('https://www.linkedin.com/in/haripritamreddyalapati/');
                    await launchUrl(url);
                  },
                ),
                SizedBox(width: 26.0),
                GestureDetector(
                  child: Image.asset(
                    'assets/twitter.png',
                    width: 32.0,
                    height: 32.0,
                  ),
                  onTap: () async {
                    Uri url = Uri.parse('https://twitter.com/haripritamreddy');
                    await launchUrl(url);
                  },
                ),
                SizedBox(width: 26.0),
                GestureDetector(
                  child: Image.asset(
                    'assets/github.png',
                    width: 32.0,
                    height: 32.0,
                  ),
                  onTap: () async {
                    Uri url = Uri.parse('https://github.com/Haripritamreddy');
                    await launchUrl(url);
                  },
                ),
                SizedBox(width: 26.0),
                GestureDetector(
                  child: Image.asset(
                    'assets/instagram.png',
                    width: 32.0,
                    height: 32.0,
                  ),
                  onTap: () async {
                    Uri url = Uri.parse('https://www.instagram.com/haripritamreddyalapati');
                    await launchUrl(url);
                  },
                ),
                SizedBox(width: 26.0),
              ],
            ),
          ),
          SizedBox(height: 50.0),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                Uri url = Uri.parse('https://www.buymeacoffee.com/haripritam');
                await launchUrl(url);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                side: BorderSide(color: Colors.white),
                minimumSize: Size(200, 40),
              ),
              child: Text('Buy me a Coffee ☕️'),
            ),
          ),
        ],
      ),
    );
  }
}