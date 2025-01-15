import 'dart:convert';
import 'package:http/http.dart' as http;
import 'article_model.dart';

class NewsService {
  final String apiKey = 'dcd342c467204320aba37a90abbf4aec';
  final String apiUrl = 'https://newsapi.org/v2/top-headlines?country=us&apiKey=';

  Future<List<Article>> fetchArticles() async {
    final response = await http.get(Uri.parse('$apiUrl$apiKey'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> body = json['articles'];
      List<Article> articles = body.map((dynamic item) => Article.fromJson(item)).toList();
      return articles;
    } else {
      throw Exception('Failed to load articles');
    }
  }
}