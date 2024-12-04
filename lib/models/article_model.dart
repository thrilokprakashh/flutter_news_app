class ArticleModel {
  final String? title;
  final String? description;
  final String? urlToImage;
  final String? url;

  ArticleModel(
      {this.title,
      this.description,
      this.urlToImage,
      this.url,
      required content});

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json['title'],
      description: json['description'],
      urlToImage: json['urlToImage'],
      url: json['url'],
      content: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
      'url': url,
    };
  }
}
