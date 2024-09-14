import 'package:flutter/material.dart';
import 'articles.dart';
import 'pages/article_detail_page.dart';
import 'package:hugeicons/hugeicons.dart';

class Article_Card extends StatelessWidget {
  const Article_Card({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: article.urlToImage != ''
            ? Image.network(
          article.urlToImage,
          width: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image);
          },
        )
            : const Icon(Icons.broken_image),
        title: Text(article.title),
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
  }
}

class HeadLine_Card extends StatelessWidget {
  const HeadLine_Card({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
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
        width: 300, // Fixed width for the Card
        margin: const EdgeInsets.only(right: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 200, // Ensure the Card has a max height of 200
              ),
              child: Card(
                child: SingleChildScrollView(
                  physics: constraints.maxHeight < 200
                      ? NeverScrollableScrollPhysics() // Disable scrolling if content fits
                      : AlwaysScrollableScrollPhysics(), // Enable scrolling if content overflows
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 120, // Fixed height for image or error icon
                        child: Image.network(
                          article.urlToImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 30.0,
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          article.title,
                          maxLines: 2, // Optional: Limit title lines to 2
                          overflow: TextOverflow.ellipsis, // Handle long text with ellipsis
                          style: const TextStyle(
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
    );
  }
}
