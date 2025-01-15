import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'article_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'articles.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE articles(id INTEGER PRIMARY KEY, title TEXT, author TEXT, description TEXT, url TEXT, urlToImage TEXT, publishedAt TEXT, content TEXT, source TEXT)',
        );
      },
    );
  }

  Future<void> insertArticle(Article article) async {
    final db = await database;
    await db.insert('articles', article.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Article>> getArticles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('articles');
    return List.generate(maps.length, (i) {
      return Article.fromJson(maps[i]);
    });
  }

  Future<void> deleteArticle(int id) async {
    final db = await database;
    await db.delete('articles', where: 'id = ?', whereArgs: [id]);
  }
}