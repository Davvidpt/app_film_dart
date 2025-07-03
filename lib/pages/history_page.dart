import 'package:flutter/material.dart';
import '../data_repository/dbhelper.dart';
import '../models/film_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HistoryPage extends StatelessWidget {
  final DBHelper dbHelper = DBHelper();

  String? getYoutubeThumbnail(String? videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl ?? '');
    if (videoId != null) {
      return 'https://img.youtube.com/vi/$videoId/0.jpg'; // Thumbnail default YouTube
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Histori Tonton')),
      body: FutureBuilder<List<Film>>(
        future: dbHelper.getHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Belum ada histori tontonan.'));
          }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final film = snapshot.data![index];
            final videoId = YoutubePlayer.convertUrlToId(film.videoUrl ?? '');
            final thumbnailUrl = videoId != null
                ? 'https://img.youtube.com/vi/$videoId/0.jpg'
                : null;

            return ListTile(
              leading: thumbnailUrl != null
                  ? Image.network(thumbnailUrl, width: 100, fit: BoxFit.cover)
                  : null,
              title: Text(film.title),
              subtitle: Text('${film.genre} • Rating: ${film.rating}'),
            );
          },
        );
        },
      ),
    );
  }
}
