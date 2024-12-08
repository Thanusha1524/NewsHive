import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todaysnews/controller/controller.dart';
import 'package:todaysnews/models/news.dart';
import 'package:todaysnews/screens/view_news.dart';

import '../db_helper/db_connection.dart';

class SearchNews extends StatelessWidget {
  final NewsController newsController = Get.put(NewsController());
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Initially fetch news with 'apple'
    newsController.fetchGeneralNews('apple');

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: const Text(
          "News Headline Hive",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          // Search TextField and Icon Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Fetch news based on the search term
                newsController.fetchGeneralNews('apple', q: _searchController.text);  // Pass the search query
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search for news...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) {
                // Fetch news when the user submits the search
                newsController.fetchGeneralNews('apple', q: value);  // Pass the search query on submission
              },
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (newsController.newsArticlesEverything.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: newsController.newsArticlesEverything.length,
            itemBuilder: (context, index) {
              var article = newsController.newsArticlesEverything[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
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
                                          id: article['title'], // Use a unique identifier (e.g., article ID)
                                          title: article['title'],
                                          description:article['description'],
                                          urlToImage: article['urlToImage'] ?? '',
                                          publishedAt: article['publishedAt'] ?? '',
                                        );
                                        // Save bookmark to database
                                        await DatabaseHelper.instance.insertBookmark(newsArticle);
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
                                    backgroundColor: MaterialStateProperty.all(Colors.black),
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
                                      icon: const Icon(Icons.add),
                                      onPressed: () {},
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
