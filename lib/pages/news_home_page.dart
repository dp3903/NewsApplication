import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../articles.dart';
import '../my_widgets.dart';

class NewsHomePage extends StatefulWidget {
  String? searchQuery;
  String? country;
  NewsHomePage({super.key, this.searchQuery, this.country});

  @override
  _NewsHomePageState createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  List<Article> _articles = [];
  List<Article> _headlines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await fetchNews();
    await fetchHeadlines();
    setState(() {
      _isLoading=false;
    });
    print(widget.searchQuery);
  }


  Future<void> fetchHeadlines() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?${widget.searchQuery==""?"":(widget.searchQuery!+"&")}country=${widget.country==""?"us":widget.country}&apiKey=7bbc1087994c470ea8b19414459fa050'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articlesJson = data['articles'];

      setState(() {
        _headlines = articlesJson.map((json) => Article.fromJson(json)).toList();
        _headlines.removeWhere((article) => (article.title == '[Removed]'));
      });
    } else {
      // Handle the error

    }
  }

  Future<void> fetchNews() async {
    print('https://newsapi.org/v2/everything?${widget.searchQuery==""?"q=news&":(widget.searchQuery!+"&")}sortBy=popularity&apiKey=7bbc1087994c470ea8b19414459fa050');
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?${widget.searchQuery==""?"q=news&":(widget.searchQuery!+"&")}sortBy=popularity&apiKey=7bbc1087994c470ea8b19414459fa050'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articlesJson = data['articles'];

      setState(() {
        _articles = articlesJson.map((json) => Article.fromJson(json)).toList();
        _articles.removeWhere((article) => article.title == '[Removed]');
      });
    } else {
      // Handle the error

    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Breaking News',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: _headlines.length!=0
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _headlines.length,
                            itemBuilder: (context, index) {
                              final article = _headlines[index];
                              return HeadLine_Card(article: article);
                            },
                          )
                        : Center(
                            child: Text(
                              "No Headlines found for your location or your preferences."
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Recent News',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _articles.length != 0
                      ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _articles.length,
                        itemBuilder: (context, index) {
                          final article = _articles[index];
                          return Article_Card(article: article);
                        },
                      )
                      : Center(
                          child: Text(
                              "No Headlines found for your location or your preferences."
                          ),
                      ),
                ],
              ),
            ),
          );
  }
}