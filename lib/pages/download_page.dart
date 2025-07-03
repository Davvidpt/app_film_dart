import 'package:flutter/material.dart';
import '../data_repository/dbhelper.dart';
import '../models/film_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  final DBHelper dbHelper = DBHelper();
  late Future<List<Film>> downloads;

  @override
  void initState() {
    super.initState();
    _loadDownloads();
  }

  void _loadDownloads() {
    setState(() {
      downloads = dbHelper.getDownloads();
    });
  }

  String? getYoutubeThumbnail(String? videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl ?? '');
    if (videoId != null) {
      return 'https://img.youtube.com/vi/$videoId/0.jpg';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Unduhan')),
      body: FutureBuilder<List<Film>>(
        future: downloads,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Belum ada film yang diunduh.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final film = snapshot.data![index];
              final thumbnailUrl = getYoutubeThumbnail(film.videoUrl);

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
