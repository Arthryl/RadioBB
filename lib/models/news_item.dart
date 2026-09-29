class NewsItem {
  final String title;
  final String link;
  final String pubDate;
  final String description;
  final String? imageUrl;
  final String author;

  const NewsItem({
    required this.title,
    required this.link,
    required this.pubDate,
    required this.description,
    this.imageUrl,
    this.author = 'Beskidzka24.pl',
  });
}
