import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsController extends GetxController {
  static const apiKey = 'c4922c51edf440dd953a3bf982b92351';
  static const _baseUrl = 'https://newsapi.org/v2';
  RxList<dynamic> newsArticles = <dynamic>[].obs;
  RxList<dynamic> newsArticlesEverything = <dynamic>[].obs;
  RxList<dynamic> newsSource = <dynamic>[].obs;


  Future<void> fetchNews(String country) async {
    const url = '$_baseUrl/top-headlines?country=us&apiKey=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print('Fetched data: $data');  // Debugging line
        newsArticles.value = data['articles'];
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  // Fetch general news from everything endpoint (with optional query)
  Future<void> fetchGeneralNews(String s, {String? q}) async {
    final searchQuery = q ?? s;
    final url = '$_baseUrl/everything?q=$searchQuery&apiKey=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print('Fetched data: $data');  // Debugging line
        newsArticlesEverything.value = data['articles'];
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchSource() async {
    const url = '$_baseUrl/top-headlines/sources?apiKey=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print('Fetched data: $data');  // Debugging line
        newsSource.value = data['sources'];
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

}
