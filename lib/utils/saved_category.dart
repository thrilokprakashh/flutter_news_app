import 'package:shared_preferences/shared_preferences.dart';

class SavedArticlesStorage {
  static const String _key = 'savedArticles';

  static Future<List<String>> getSavedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  static Future<void> saveArticles(List<String> articles) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, articles);
  }

  static Future<void> addArticle(String articleJson) async {
    final articles = await getSavedArticles();
    articles.add(articleJson);
    await saveArticles(articles);
  }

  static Future<void> removeArticle(String articleJson) async {
    final articles = await getSavedArticles();
    articles.remove(articleJson);
    await saveArticles(articles);
  }
}
