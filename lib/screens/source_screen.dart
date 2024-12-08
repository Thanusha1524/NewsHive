import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/controller.dart';

class SourceScreen extends StatelessWidget {
  final NewsController _newsController = Get.find();

  SourceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Trigger fetching of sources
    _newsController.fetchSource();

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Sources'),
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        // Check if the data is loading or empty
        if (_newsController.newsSource.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          // Display the list of sources
          return ListView.builder(
            itemCount: _newsController.newsSource.length,
            itemBuilder: (context, index) {
              final source = _newsController.newsSource[index];
              return Card(
                margin: const EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Source Name
                      Text(
                        source['name'] ?? 'No Name',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Source Description
                      Text(
                        source['description'] ?? 'No Description',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      // Additional Details
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Category: ${source['category'] ?? 'N/A'}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 10), // Add spacing between items
                              Text(
                                "Language: ${source['language'] ?? 'N/A'}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5), // Add spacing between rows
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Country: ${source['country'] ?? 'N/A'}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Open Website Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            final url = source['url'];
                            if (url != null) {
                              Get.snackbar(
                                'Redirecting...',
                                'Opening ${source['name']} in browser.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                              // You can use a URL launcher plugin to open the link
                              // For example, launchUrl(url);
                            } else {
                              Get.snackbar(
                                'Error',
                                'URL not found for this source.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Visit Website'),
                        ),
                      ),
                    ],
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
