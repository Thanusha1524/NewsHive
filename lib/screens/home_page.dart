import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todaysnews/controller/controller.dart';
import 'package:todaysnews/models/news.dart';
import 'package:todaysnews/screens/view_news.dart';

import '../db_helper/db_connection.dart';

class HomeScreen extends StatelessWidget {
  final NewsController newsController = Get.put(NewsController());

  @override
  Widget build(BuildContext context) {
    // Fetch news
    newsController.fetchNews('us');

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: const Text("News Headline Hive", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Obx(() {
        if (newsController.newsArticles.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: newsController.newsArticles.length,
            itemBuilder: (context, index) {
              var article = newsController.newsArticles[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 360, // Fixed height for each article container
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Navigate to ViewNewsPage on card tap
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewNewsPage(article: NewsArticle(
                              id: article['title'],
                              title: article['title'],
                              description: article['description'],
                              urlToImage: article['urlToImage'] ?? '',
                              publishedAt: article['publishedAt'] ?? '',
                            )),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          // Image section
                          if (article['urlToImage'] != null)
                            Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                                    child: Image.network(
                                      article['urlToImage']!,
                                      height: 140,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 22,
                                  right: 22,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.bookmark_border,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      onPressed: () async {
                                        var newsArticle = NewsArticle(
                                          id: article['title'],
                                          title: article['title'],
                                          description: article['description'],
                                          urlToImage: article['urlToImage'] ?? '',
                                          publishedAt: article['publishedAt'] ?? '',
                                        );
                                        await DatabaseHelper.instance.insertBookmark(newsArticle);

                                        // Show confirmation snackbar
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Article bookmarked!')),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          // Content Section (Title, Description, Author)
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article['title'] ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    (article['author']?.split(' ').take(3).join(' ') ?? ''),
                                    style: const TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Padding(padding: EdgeInsets.all(2.0)),
                                        const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                        const SizedBox(width: 5),
                                        Text(
                                          article['publishedAt'] != null
                                              ? DateFormat('yMMMd').format(DateTime.parse(article['publishedAt']))
                                              : '',
                                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.share),
                                      onPressed: () {
                                        final String shareContent = "${article['title']} - ${article['url']}";
                                        Share.share(shareContent);
                                      },
                                    ),
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
              );
            },
          );
        }
      }),
    );
  }
}
