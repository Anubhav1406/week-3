import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'article_model.dart';
import 'detail_screen.dart';

class SavedScreen extends StatefulWidget {
  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  late Future<List<Article>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = DatabaseHelper().getArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Articles'),
      ),
      body: FutureBuilder<List<Article>>(
        future: futureArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No saved articles'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Article article = snapshot.data![index];
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
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await DatabaseHelper().deleteArticle(article.id);
                      setState(() {
                        futureArticles = DatabaseHelper().getArticles();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Article removed')));
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}