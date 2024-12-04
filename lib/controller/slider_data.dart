import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/models/slider_model.dart';

class SliderData {
  List<SliderModel> sliders = [];
  Future<void> getSlider() async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=248001e66ca94de39c6bb7ab94eb4143";
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          SliderModel sliderModel = SliderModel(
            title: element['title'],
            description: element['description'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            content: element['content'],
          );
          sliders.add(sliderModel);
        }
      });
    }
  }
}
