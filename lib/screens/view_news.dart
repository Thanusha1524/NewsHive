import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todaysnews/models/news.dart';

class ViewNewsPage extends StatelessWidget {
  final NewsArticle article;

  // Constructor to accept article data
  ViewNewsPage({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text(article.title),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article.urlToImage.isNotEmpty)
                Image.network(
                  article.urlToImage,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 12),
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                article.publishedAt.isNotEmpty
                    ? DateFormat('yMMMd').format(DateTime.parse(article.publishedAt))
                    : 'Date not available',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                article.description, // You can add more content from the article if available.
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
