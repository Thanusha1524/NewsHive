import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todaysnews/screens/book_mark_page.dart';
import 'package:todaysnews/screens/favorite_news.dart';
import 'package:todaysnews/screens/home_page.dart';
import 'package:todaysnews/screens/search_news.dart';
import 'package:todaysnews/screens/source_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
      return const GetMaterialApp(
        title: 'News Headline Hive',
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    SearchNews(),
    SourceScreen(),
    BookmarkedArticlesScreen()
    // Add other screens if necessary
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.source, size: 30),
          Icon(Icons.bookmark, size: 30),
        ],
        onTap: _onItemTapped,
      ),
      body: _screens[_selectedIndex],
    );
  }
}