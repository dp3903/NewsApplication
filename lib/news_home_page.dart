import 'package:flutter/material.dart';
import './news_home_page_content.dart';
import './trending_page.dart';

class NewsHomePage extends StatefulWidget {
  @override
  _NewsHomePageState createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    NewsHomePageContent(),
    TrendingPage(),
    Center(child: Text('Saved Page')), // Placeholder for Saved page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NewsApp'),
      ),
      body: _pages[_currentIndex],  // Display the current page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,  // Highlight the current tab
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Trending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
        ],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
