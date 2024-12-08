import 'package:flutter/material.dart';
import 'package:todaysnews/models/news.dart';
import '../db_helper/db_connection.dart';

class BookmarkedArticlesScreen extends StatefulWidget {
  @override
  _BookmarkedArticlesScreenState createState() =>
      _BookmarkedArticlesScreenState();
}

class _BookmarkedArticlesScreenState extends State<BookmarkedArticlesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: const Text('Bookmarked Articles'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<NewsArticle>>(
        future: DatabaseHelper.instance.getAllBookmarks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookmarked articles.'));
          } else {
            final bookmarks = snapshot.data!;
            return ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final article = bookmarks[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Navigate to View News page if needed
                      },
                      child: Column(
                        children: [
                          // Article Image
                          if (article.urlToImage.isNotEmpty)
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                              child: Image.network(
                                article.urlToImage,
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Article Title
                                Text(
                                  article.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Article Date
                                Text(
                                  article.publishedAt,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Action Buttons (Edit and Delete)
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Edit Button
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    // Navigate to a screen to edit the article
                                    _editBookmark(context, article);
                                  },
                                ),
                                // Delete Button
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    // Delete article from the database
                                    await DatabaseHelper.instance.deleteBookmark(article.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Article deleted')),
                                    );
                                    setState(() {}); // Refresh the list after deletion
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Method to navigate to the Edit screen
  // Method to navigate to the Edit screen
  void _editBookmark(BuildContext context, NewsArticle article) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController titleController = TextEditingController(text: article.title);
        TextEditingController descriptionController = TextEditingController(text: article.description);

        return AlertDialog(
          title: const Text('Edit Bookmark'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Update the article in the database
                final updatedArticle = article.copyWith(
                  title: titleController.text,
                  description: descriptionController.text,
                );
                await DatabaseHelper.instance.updateBookmark(updatedArticle);

                // Show snackbar and refresh the list
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Article updated')),
                );

                Navigator.of(context).pop(); // Close the dialog
                setState(() {}); // Refresh the list after update
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
