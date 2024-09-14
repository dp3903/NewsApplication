import 'package:flutter/material.dart';
import 'package:news_app/pages/custom_profile_page.dart';
import './pages/preferences_page.dart';
import './pages/news_home_page.dart';
import './pages/trending_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int _currentIndex = 0;
  String _country = "";

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


  Future<String> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position my_position = await Geolocator.getCurrentPosition();

    final response = await http.get(Uri.parse('https://nominatim.openstreetmap.org/reverse?lat=${my_position.latitude}&lon=${my_position.longitude}&format=json'));
    // https://nominatim.openstreetmap.org/reverse?lat=LATITUDE&lon=LONGITUDE&format=json
    // Use this endpoint to get free location data as city, state and country details from latitude and longitude.
    // Only 1 request per second per IP allowed

    Map<dynamic,dynamic> body = json.decode(response.body);
    // print(body);
    return body["address"]["country_code"];
    // return body.toString();
  }


  @override
  void initState() {
    super.initState();
    _determinePosition().then(
        (data) => {
          setState(() {
            _country = data;
          })
        }
    );

    // Initialize selectedKeywords with all values set to false
    for (String keyword in keywords) {
      selectedKeywords[keyword] = false;
    }
  }

  List<Widget> _pages = [];

  @override
  Widget build(BuildContext context) {

    _pages = [
      NewsHomePage(searchQuery: keywordQuery, country: _country,),
      const TrendingPage(),
      PreferencesPage(
        preferences: selectedKeywords,
        onChange: onChange,
        onConfirm: handleConfirm,
      ),
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
