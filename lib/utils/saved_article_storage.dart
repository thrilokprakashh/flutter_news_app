import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_app/models/article_model.dart';

class SavedArticlesStorage {
  static const String _key = "saved_articles";

  static Future<void> saveArticles(List<ArticleModel> articles) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> articlesJson =
        articles.map((article) => jsonEncode(article.toJson())).toList();
    prefs.setStringList(_key, articlesJson);
  }

  static Future<List<ArticleModel>> loadArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? articlesJson = prefs.getStringList(_key);
    if (articlesJson == null) return [];
    return articlesJson
        .map((json) => ArticleModel.fromJson(jsonDecode(json)))
        .toList();
  }

  static getSavedArticles() {}

  static removeArticle(String articleJson) {}

  static addArticle(String articleJson) {}
}
