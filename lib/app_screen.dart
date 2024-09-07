import 'package:flutter/material.dart';
import 'package:news_app/pages/custom_profile_page.dart';
import './pages/preferences_page.dart';
import './pages/news_home_page.dart';
import './pages/trending_page.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int _currentIndex = 0;

  String keywordQuery = "";
  final List<String> keywords = [
    'Finance',
    'Life',
    'Politics',
    'Technology',
    'Sports',
    'BlockChain',
    'BitCoin',
    'Entertainment',
    'Etherium',
    'Stocks',
    'StockMarket',
    'Health',
    'Criminal',
    'Science',
    'Exams',
    'Students',
    'Games',
  ];

  // Map to keep track of selected keywords
  Map<String, bool> selectedKeywords = {};

  void onChange(String keyword, bool state){
    setState(() {
      selectedKeywords[keyword] = state;
    });
  }

  void handleConfirm(){
    String query = "";
    selectedKeywords.forEach((key,val)=>{
      if(val){
        query += (key+"+")
      }
    });
    if(query!=""){
      query = "q="+query;
      query = query.substring(0,query.length-1);
    }

    setState(() {
      keywordQuery=query;
    });

    // print(keywordQuery);
  }


  @override
  void initState() {
    super.initState();
    // Initialize selectedKeywords with all values set to false
    for (String keyword in keywords) {
      selectedKeywords[keyword] = false;
    }
  }

  List<Widget> _pages = [];

  @override
  Widget build(BuildContext context) {

    _pages = [
      NewsHomePage(searchQuery: keywordQuery,),
      const TrendingPage(),
      PreferencesPage(
        preferences: selectedKeywords,
        onChange: onChange,
        onConfirm: handleConfirm,
      ),
      const Center(child: Text('Saved Page')),
      const CustomProfilePage(),
    ];

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
            icon: Icon(Icons.tune),
            label: 'Preferences',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
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
