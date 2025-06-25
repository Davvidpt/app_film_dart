class Film {
  final int? id;
  final String title;
  final String genre;
  final double rating;

  Film({this.id, required this.title, required this.genre, required this.rating});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'genre': genre, 'rating': rating};
  }
}