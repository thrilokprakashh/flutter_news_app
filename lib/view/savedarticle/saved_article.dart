import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/utils/saved_article_storage.dart';
import 'package:news_app/view/homescreen/home_screen.dart';

class SavedArticlesScreen extends StatefulWidget {
  final List<ArticleModel> savedArticles;

  SavedArticlesScreen({required this.savedArticles});

  @override
  State<SavedArticlesScreen> createState() => _SavedArticlesScreenState();
}

class _SavedArticlesScreenState extends State<SavedArticlesScreen> {
  late List<ArticleModel> articles;
  @override
  void initState() {
    super.initState();
    articles =
        widget.savedArticles; // Initialize with the passed saved articles
  }

  void _removeArticle(ArticleModel article) async {
    setState(() {
      articles.remove(article); // Remove the article from the list
    });
    await SavedArticlesStorage.saveArticles(articles); // Persist changes
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Article removed from saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Saved Articles",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
      body: widget.savedArticles.isEmpty
          ? Center(
              child: Text("No saved articles."),
            )
          : ListView.builder(
              itemCount: widget.savedArticles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return BlogTile(
                  desc: widget.savedArticles[index].description ??
                      "No Description",
                  imageUrl: widget.savedArticles[index].urlToImage ?? "",
                  title: widget.savedArticles[index].title ?? "No Title",
                  url: widget.savedArticles[index].url!,
                  isSaved: articles.contains(articles),

                  

                  onSave: () =>
                      _removeArticle(article), // Remove on button press
                );
              },
            ),
    );
  }
}
