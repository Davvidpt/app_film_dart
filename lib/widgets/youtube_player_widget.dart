import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerWidget extends StatelessWidget {
  final String videoUrl;

  YouTubePlayerWidget({required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    return Scaffold(
      appBar: AppBar(title: Text('Tonton Video')),
      body: videoId == null
          ? Center(child: Text('Link tidak valid'))
          : YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: videoId,
                flags: YoutubePlayerFlags(autoPlay: true),
              ),
              showVideoProgressIndicator: true,
            ),
    );
  }
}
