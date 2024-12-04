import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/models/article_model.dart';

class AllCategoryNews {
  List<ArticleModel> allCategory = [];

  Future<void> getAllCategoryNews({String category = ''}) async {
    String url;

    if (category.isEmpty || category.toLowerCase() == 'all') {
      url =
          "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=248001e66ca94de39c6bb7ab94eb4143";
    } else {
      url =
          "https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=248001e66ca94de39c6bb7ab94eb4143";
    }

    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      allCategory = [];
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            description: element['description'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            content: element['content'],
          );
          allCategory.add(articleModel);
        }
      });
    }
  }
}
