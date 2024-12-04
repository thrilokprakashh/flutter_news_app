import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/controller/show_category_news.dart';
import 'package:news_app/models/show_category_model.dart';
import 'package:news_app/view/articleview/article_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding/decoding

class CategoryNews extends StatefulWidget {
  String name;
  CategoryNews({required this.name});

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ShowCategoryModel> categories = [];
  bool _Loading = true;

  @override
  void initState() {
    super.initState();
    getNews();
  }

  getNews() async {
    ShowCategoryNews showCategoryNews = ShowCategoryNews();
    await showCategoryNews.getcategoriesNews(widget.name.toLowerCase());
    categories = showCategoryNews.categories;
    setState(() {
      _Loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _Loading
          ? _buildShimmerEffect()
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return ShowCategory(
                    article: categories[index],
                  );
                },
              ),
            ),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
                SizedBox(height: 5),
                Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width * 0.7,
                  color: Colors.white,
                ),
                SizedBox(height: 5),
                Container(
                  height: 15,
                  width: MediaQuery.of(context).size.width * 0.5,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ShowCategory extends StatefulWidget {
  final ShowCategoryModel article;

  ShowCategory({required this.article});

  @override
  State<ShowCategory> createState() => _ShowCategoryState();
}

class _ShowCategoryState extends State<ShowCategory> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    checkIfSaved();
  }

  // Check if the article is already saved
  void checkIfSaved() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedArticles = prefs.getStringList('savedArticles') ?? [];
    setState(() {
      isSaved = savedArticles.contains(jsonEncode(widget.article.toJson()));
    });
  }

  // Save or unsave the article
  void toggleSave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedArticles = prefs.getStringList('savedArticles') ?? [];
    String articleJson = jsonEncode(widget.article.toJson());

    setState(() {
      if (isSaved) {
        savedArticles.remove(articleJson);
        isSaved = false;
      } else {
        savedArticles.add(articleJson);
        isSaved = true;
      }
    });

    await prefs.setStringList('savedArticles', savedArticles);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleView(blogUrl: widget.article.url!),
          ),
        );
      },
      child: Container(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                placeholder: (context, url) => Shimmer.fromColors(
                  child: Container(
                    height: 100,
                    width: 100,
                    color: Colors.white,
                  ),
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                ),
                errorWidget: (context, url, error) => Image.asset(
                  "assets/pexels-markusspiske-102155.jpg",
                  fit: BoxFit.cover,
                ),
                imageUrl: widget.article.urlToImage!,
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5),
            Text(
              widget.article.title!,
              maxLines: 2,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              widget.article.description!,
              maxLines: 3,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: toggleSave,
                  child: Row(
                    children: [
                      Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 5),
                      Text(isSaved ? "Saved" : "Save"),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
