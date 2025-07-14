import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/film_list_page.dart';
import 'pages/film_detail_page.dart';
import 'pages/history_page.dart';
import 'pages/download_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';

void main() {
  runApp(FilmApp());
}

class FilmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Film App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
        routes: {
        '/': (context) => LoginPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/filmList': (context) => FilmListPage(),
        '/history': (context) => HistoryPage(),
        '/download': (context) => DownloadPage(),
        },
    );
  }
  }
