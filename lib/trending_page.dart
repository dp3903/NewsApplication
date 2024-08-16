import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hugeicons/hugeicons.dart';
import 'dart:convert';
import './articles.dart';
import './article_detail_page.dart';

class TrendingPage extends StatefulWidget {
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
        title: Text('Trending News'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _trendingArticles.length,
        itemBuilder: (context, index) {
          final article = _trendingArticles[index];
          return Card(
            margin: EdgeInsets.all(10.0),
            child: ListTile(
              leading: article.urlToImage != ''
                  ? Image.network(
                article.urlToImage,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image);
                },
              )
                  : Icon(Icons.broken_image),
              title: Text(article.title),
              subtitle: Text(article.description),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailPage(article: article),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
