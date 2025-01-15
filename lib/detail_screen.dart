import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'article_model.dart';

class DetailScreen extends StatelessWidget {
  final Article article;

  DetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              await DatabaseHelper().insertArticle(article);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Article saved')));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            article.urlToImage != null
                ? Image.network(article.urlToImage!)
                : Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                article.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('By ${article.author ?? 'Unknown author'}'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Source: ${article.source['name'] ?? 'Unknown source'}'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Published: ${article.publishedAt}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                article.content ?? 'No content available',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}