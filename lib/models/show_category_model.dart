class ShowCategoryModel {
  String? id; // Unique ID for the article
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? content;

  ShowCategoryModel({
    this.id,
    this.author,
    this.content,
    this.description,
    this.title,
    this.url,
    this.urlToImage,
  });

  // Factory constructor to create an instance from JSON
  factory ShowCategoryModel.fromJson(Map<String, dynamic> json) {
    return ShowCategoryModel(
      id: json['url'], // Use URL as a unique identifier
      author: json['author'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      content: json['content'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'content': content,
    };
  }

  // Override equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShowCategoryModel && other.id == id;
  }

  // Override hashCode
  @override
  int get hashCode => id.hashCode;
}
