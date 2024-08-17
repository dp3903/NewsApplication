import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/my_widgets.dart';
import 'dart:convert';
import '../articles.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});

  @override
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  List<Article> _trendingArticles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTrendingNews();
  }

  Future<void> fetchTrendingNews() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=trending&sortBy=popularity&apiKey=7bbc1087994c470ea8b19414459fa050'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articlesJson = data['articles'];

      setState(() {
        _trendingArticles =
            articlesJson.map((json) => Article.fromJson(json)).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending News'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _trendingArticles.length,
        itemBuilder: (context, index) {
          final article = _trendingArticles[index];
          return Article_Card(article: article);
        },
      ),
    );
  }
}
