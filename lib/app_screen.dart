import 'package:flutter/material.dart';
import './pages/news_home_page.dart';
import './pages/trending_page.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const NewsHomePage(),
    const TrendingPage(),
    const Center(child: Text('Saved Page')), // Placeholder for Saved page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NewsApp'),
      ),
      body: _pages[_currentIndex],  // Display the current page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,  // Highlight the current tab
        items: const [
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
