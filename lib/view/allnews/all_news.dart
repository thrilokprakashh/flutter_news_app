import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_app/controller/news.dart';
import 'package:news_app/controller/slider_data.dart';
import 'package:shimmer/shimmer.dart';

import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/slider_model.dart';
import 'package:news_app/utils/saved_article_storage.dart';
import 'package:news_app/view/articleview/article_view.dart';

class AllNews extends StatefulWidget {
  final String news;
  AllNews({required this.news});

  @override
  State<AllNews> createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
  List<SliderModel> sliders = [];
  List<ArticleModel> articles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getSlider();
    getNews();
  }

  Future<void> getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    setState(() {
      articles = newsClass.news;
      _loading = false;
    });
  }

  Future<void> getSlider() async {
    SliderData slider = SliderData();
    await slider.getSlider();
    sliders = slider.sliders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.news} News",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _loading
          ? _buildShimmerEffect()
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                itemCount: widget.news == "Breaking"
                    ? sliders.length
                    : articles.length,
                itemBuilder: (context, index) {
                  final isBreaking = widget.news == "Breaking";
                  return AllNewsSection(
                    image: isBreaking
                        ? sliders[index].urlToImage!
                        : articles[index].urlToImage!,
                    desc: isBreaking
                        ? sliders[index].description!
                        : articles[index].description!,
                    title: isBreaking
                        ? sliders[index].title!
                        : articles[index].title!,
                    url:
                        isBreaking ? sliders[index].url! : articles[index].url!,
                    articleJson: isBreaking
                        ? jsonEncode(sliders[index].toJson())
                        : jsonEncode(articles[index].toJson()),
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

class AllNewsSection extends StatefulWidget {
  final String image, desc, title, url, articleJson;

  AllNewsSection({
    required this.image,
    required this.desc,
    required this.title,
    required this.url,
    required this.articleJson,
  });

  @override
  State<AllNewsSection> createState() => _AllNewsSectionState();
}

class _AllNewsSectionState extends State<AllNewsSection> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    checkIfSaved();
  }

  Future<void> checkIfSaved() async {
    final savedArticles = await SavedArticlesStorage.getSavedArticles();
    setState(() {
      isSaved = savedArticles.contains(widget.articleJson);
    });
  }

  Future<void> toggleSave() async {
    if (isSaved) {
      await SavedArticlesStorage.removeArticle(widget.articleJson);
    } else {
      await SavedArticlesStorage.addArticle(widget.articleJson);
    }
    setState(() {
      isSaved = !isSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleView(blogUrl: widget.url),
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
                errorWidget: (context, url, error) =>
                    Image.asset("assets/pexels-markusspiske-102155.jpg"),
                imageUrl: widget.image,
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5),
            Text(
              widget.title,
              maxLines: 2,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Text(widget.desc, maxLines: 3),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.blue,
                  ),
                  onPressed: toggleSave,
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
