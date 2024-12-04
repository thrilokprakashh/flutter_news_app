import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/controller/all_category_news.dart';

import 'package:news_app/models/article_model.dart';
import 'package:news_app/view/articleview/article_view.dart';
import 'package:shimmer/shimmer.dart';

class NewsSearchScreen extends StatefulWidget {
  @override
  _NewsSearchScreenState createState() => _NewsSearchScreenState();
}

class _NewsSearchScreenState extends State<NewsSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ArticleModel> _filteredArticles = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';
  List<String> _categories = [
    'All',
    'Business',
    'Entertainment',
    'Health',
    'Science',
    'Sports',
    'Technology'
  ];

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    setState(() {
      _isLoading = true;
    });

    AllCategoryNews newsController = AllCategoryNews();
    await newsController.getAllCategoryNews(
        category: _selectedCategory.toLowerCase() == 'all'
            ? ''
            : _selectedCategory.toLowerCase());
    setState(() {
      _filteredArticles = newsController.allCategory;
      _isLoading = false;
    });
  }

  void _filterArticles(String query) {
    if (query.isEmpty) {
      _fetchNews();
    } else {
      setState(() {
        _filteredArticles = _filteredArticles
            .where((article) =>
                article.title!.toLowerCase().contains(query.toLowerCase()) ||
                article.description!
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Dropdown
            DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              items: _categories
                  .map((category) =>
                      DropdownMenuItem(value: category, child: Text(category)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                  _fetchNews();
                });
              },
            ),
            SizedBox(height: 10),

            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search for news, topics, or categories...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => _filterArticles(value),
            ),
            SizedBox(height: 20),

            // Display Articles
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: _filteredArticles.isNotEmpty
                        ? ListView.builder(
                            itemCount: _filteredArticles.length,
                            itemBuilder: (context, index) {
                              final article = _filteredArticles[index];
                              return ListTile(
                                leading: article.urlToImage != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                                  child: Container(
                                                    height: 100,
                                                    width: 100,
                                                    color: Colors.white,
                                                  ),
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            "assets/pexels-markusspiske-102155.jpg",
                                            fit: BoxFit.cover,
                                          ),
                                          imageUrl: article.urlToImage!,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Icon(Icons.image, size: 60),
                                title: Text(
                                  article.title ?? "No Title",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                  maxLines: 2,
                                ),
                                subtitle: Text(
                                  article.description ?? "No Description",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  // Navigate to article details or open the URL
                                  _launchUrl(article.url);
                                },
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              "No results found.",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                  ),
          ],
        ),
      ),
    );
  }

  void _launchUrl(String? url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleView(blogUrl: url.toString()),
      ),
    );
  }
}
