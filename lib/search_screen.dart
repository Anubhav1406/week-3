import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'article_model.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Article> _articles = [];
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _searchArticles(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final String apiKey = 'dcd342c467204320aba37a90abbf4aec';
    final String apiUrl = 'https://newsapi.org/v2/everything?q=$query&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['articles'];
        List<Article> articles = body.map((dynamic item) => Article.fromJson(item)).toList();

        setState(() {
          _articles = articles;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load articles';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search here',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (query) {
                _searchArticles(query);
              },
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : _errorMessage.isNotEmpty
                ? Text(_errorMessage)
                : Expanded(
              child: ListView.builder(
                itemCount: _articles.length,
                itemBuilder: (context, index) {
                  Article article = _articles[index];
                  return ListTile(
                    leading: article.urlToImage != null
                        ? Image.network(article.urlToImage!)
                        : null,
                    title: Text(article.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(article.source['name'] ?? 'Unknown source'),
                        Text(article.publishedAt),
                        Text(article.author ?? 'Unknown author'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(article: article),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}