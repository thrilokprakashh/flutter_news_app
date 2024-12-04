import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news_app/controller/data.dart';
import 'package:news_app/controller/news.dart';
import 'package:news_app/controller/slider_data.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/category_model.dart';
import 'package:news_app/models/slider_model.dart';
import 'package:news_app/utils/saved_article_storage.dart';
import 'package:news_app/view/%20categorynews/category_news.dart';
import 'package:news_app/view/allnews/all_news.dart';
import 'package:news_app/view/articleview/article_view.dart';
import 'package:news_app/view/drawerSection/my_Drawer.dart';
import 'package:news_app/view/savedarticle/saved_article.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  final List<ArticleModel> savedArticles;
  const HomeScreen({super.key, required this.savedArticles});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CategoryModel> categorie = [];
  List<SliderModel> sliders = [];
  List<ArticleModel> articles = [];
  List<ArticleModel> savedArticles = [];

  bool _loading = true;
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    categorie = getCategories();
    getSlider();
    getNews();
    _loadSavedArticle();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    setState(() {
      articles = newsClass.news;
      _loading = false;
    });
  }

  getSlider() async {
    SliderData slider = SliderData();
    await slider.getSlider();
    setState(() {
      sliders = slider.sliders;
    });
  }

  Future<void> _loadSavedArticle() async {
    savedArticles = await SavedArticlesStorage.loadArticles();
    setState(() {});
  }

  Future<void> _toggleSave(ArticleModel article) async {
    setState(() {
      if (savedArticles.contains(article)) {
        savedArticles.remove(article);
      } else {
        savedArticles.add(article);
      }
    });
    await SavedArticlesStorage.saveArticles(savedArticles);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          savedArticles.contains(article)
              ? 'Article saved!'
              : 'Article removed from saved!',
        ),
        duration:
            Duration(seconds: 2), // Duration for which the snackbar is visible
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Flutter"),
            Text(
              "News",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SavedArticlesScreen(
                    savedArticles: savedArticles,
                  ),
                ),
              );
            },
            icon: Icon(Icons.bookmark),
          ),
        ],
        centerTitle: true,
        elevation: 0.0,
      ),
      drawer: MyDrawer(),
      body: _loading
          ? _buildShimmerEffect()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories Section
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 70,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: categorie.length,
                      itemBuilder: (context, index) {
                        return categoryTile(
                          image: categorie[index].image,
                          categoryName: categorie[index].categoryName,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 30),

                  // Breaking News Section
                  sectionHeader(
                    title: "Breaking News!",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllNews(news: "Breaking"),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Slider Section
                  CarouselSlider.builder(
                    itemCount: sliders.length,
                    itemBuilder: (context, index, realIndex) {
                      if (sliders.isEmpty) {
                        return buildImage(
                            "assets/pexels-markusspiske-102155.jpg",
                            index,
                            "No data available");
                      }
                      String? imageUrl = sliders[index].urlToImage;
                      String? title = sliders[index].title;
                      return buildImage(
                          imageUrl ?? "assets/pexels-markusspiske-102155.jpg",
                          index,
                          title ?? "No Title");
                    },
                    options: CarouselOptions(
                      height: 250,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      autoPlay: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          activeIndex = index;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(child: buildIndicator()),
                  const SizedBox(
                    height: 20,
                  ),

                  // Trending News Section
                  sectionHeader(
                    title: "Trending News!",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllNews(news: "Trending"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Trending News List
                  articles.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "No trending news available now",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final article = articles[index];

                            return BlogTile(
                              url: articles[index].url!,
                              desc: articles[index].description ??
                                  "No Description",
                              imageUrl:
                                  articles[index].urlToImage ?? "no image ",
                              title: articles[index].title ?? "No Title",
                              isSaved: savedArticles.contains(articles),
                              onSave: () => _toggleSave(article),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }

  Widget buildImage(String image, int index, String name) => Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Stack(
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
                    highlightColor: Colors.grey[100]!),
                errorWidget: (context, url, error) => Image.asset(
                  "assets/pexels-markusspiske-102155.jpg",
                  fit: BoxFit.cover,
                ),
                height: 250,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                imageUrl: image.isNotEmpty
                    ? image
                    : "assets/pexels-markusspiske-102155.jpg",
              ),
            ),
            Container(
              height: 250,
              padding: EdgeInsets.only(left: 10),
              margin: EdgeInsets.only(top: 170),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                name,
                maxLines: 2,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ],
        ),
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: 5,
        effect: SlideEffect(
            dotHeight: 15, dotWidth: 15, activeDotColor: Colors.blue),
      );

  Widget sectionHeader({required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              "View All",
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 5, // Number of shimmer items
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

class categoryTile extends StatelessWidget {
  final image, categoryName;

  const categoryTile({super.key, this.image, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryNews(
                name: categoryName,
              ),
            ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                image,
                width: 120,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 120,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  categoryName,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc, url;
  final bool isSaved;
  final VoidCallback onSave;
  BlogTile(
      {required this.desc,
      required this.imageUrl,
      required this.title,
      required this.url,
      required this.isSaved,
      required this.onSave});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleView(blogUrl: url),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Shimmer.fromColors(
                            child: Container(
                              height: 100,
                              width: 100,
                              color: Colors.white,
                            ),
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!),
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/pexels-markusspiske-102155.jpg",
                          fit: BoxFit.cover,
                        ),
                        imageUrl: imageUrl.isNotEmpty
                            ? imageUrl
                            : "assets/pexels-markusspiske-102155.jpg",
                        height: 100,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(height: 5),
                        Text(
                          desc,
                          maxLines: 2,
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                onPressed: onSave,
                                icon: Icon(
                                  Icons.bookmark,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  Share.share(
                                    'Check out this article: $title\n\n$url',
                                    subject: 'Flutter News Article',
                                  );
                                },
                                icon: Icon(
                                  Icons.share,
                                  color: Colors.blue,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
