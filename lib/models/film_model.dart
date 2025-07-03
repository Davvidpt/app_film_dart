class Film {
  int? id;
  String title;
  String genre;
  double rating;
  String? videoUrl;

  Film({
    this.id,
    required this.title,
    required this.genre,
    required this.rating,
    this.videoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'genre': genre,
      'rating': rating,
      'videoUrl': videoUrl,
    };
  }

factory Film.fromMap(Map<String, dynamic> map) {
  return Film(
    id: map['id'],
    title: map['title'],
    genre: map['genre'],
    rating: map['rating'] != null ? (map['rating'] as num).toDouble() : 0.0,
    videoUrl: map['videoUrl'],
  );
}
}
