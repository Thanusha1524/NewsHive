class NewsArticle {
  final String id;
  final String title;
  final String urlToImage;
  final String publishedAt;
  final String description;

  NewsArticle({
    required this.id,
    required this.title,
    required this.urlToImage,
    required this.publishedAt, required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'description':description
    };
  }

  factory NewsArticle.fromMap(Map<String, dynamic> map) {
    return NewsArticle(
      id: map['id'],
      title: map['title'],
      urlToImage: map['urlToImage'],
      publishedAt: map['publishedAt'],
        description:map['description']
    );
  }

  NewsArticle copyWith({
    int? id,
    String? title,
    String? description,
    String? urlToImage,
    String? publishedAt,
  }) {
    return NewsArticle(
      id: this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      urlToImage: urlToImage ?? this.urlToImage,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }
}
