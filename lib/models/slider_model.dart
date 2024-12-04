class SliderModel {
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? content;

  SliderModel({
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.content,
  });

  // Factory method to create a SliderModel from a JSON map
  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      author: json['author'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      content: json['content'],
    );
  }

  // Method to convert a SliderModel instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'content': content,
    };
  }
}
