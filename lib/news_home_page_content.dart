import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './articles.dart';
import './article_detail_page.dart';
import 'package:hugeicons/hugeicons.dart';

class NewsHomePageContent extends StatefulWidget {
  @override
  _NewsHomePageContentState createState() => _NewsHomePageContentState();
}

class _NewsHomePageContentState extends State<NewsHomePageContent> {
  List<Article> _articles = [];
  List<Article> _headlines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
    fetchHeadlines();
  }

  Future<void> fetchHeadlines() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=in&apiKey=7bbc1087994c470ea8b19414459fa050'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articlesJson = data['articles'];

      setState(() {
        _headlines = articlesJson.map((json) => Article.fromJson(json)).toList();
        _isLoading = false;
      });
    } else {
      // Handle the error
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchNews() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=Apple&from=2024-08-01&sortBy=popularity&apiKey=7bbc1087994c470ea8b19414459fa050'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articlesJson = data['articles'];

      setState(() {
        _articles = articlesJson.map((json) => Article.fromJson(json)).toList();
        _isLoading = false;
      });
    } else {
      // Handle the error
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Breaking News',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _headlines.length,
                itemBuilder: (context, index) {
                  final article = _headlines[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleDetailPage(article: article),
                        ),
                      );
                    },
                    child: Container(
                      width: 300,
                      margin: EdgeInsets.only(right: 16),
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.network(
                              article.urlToImage,
                              width: double.infinity,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: HugeIcon(
                                    icon: HugeIcons.strokeRoundedAlbumNotFound01,
                                    color: Colors.red,
                                    size: 30.0,
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                article.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Recent News',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _articles.length,
              itemBuilder: (context, index) {
                final article = _articles[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
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
          ],
        ),
      ),
    );
  }
}
