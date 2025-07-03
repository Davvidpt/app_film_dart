// import 'package:flutter/material.dart';
// import '../models/film_model.dart';
// import 'dart:async';
// import '../data_repository/dbhelper.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
// class FilmDetailPage extends StatefulWidget {
//   final Film film;
//
//   const FilmDetailPage({Key? key, required this.film}) : super(key: key);
//
//   @override
//   _FilmDetailPageState createState() => _FilmDetailPageState();
// }
//
// class _FilmDetailPageState extends State<FilmDetailPage> {
//   double progress = 0.0;
//   StreamSubscription? downloadSubscription;
//
//   late YoutubePlayerController _youtubeController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     final videoId = YoutubePlayer.convertUrlToId(widget.film.videoUrl ?? '');
//     _youtubeController = YoutubePlayerController(
//       initialVideoId: videoId ?? '',
//       flags: YoutubePlayerFlags(
//         autoPlay: false,
//         mute: false,
//       ),
//     );
//       if (widget.film.videoUrl != null && widget.film.videoUrl!.isNotEmpty) {
//         DBHelper().insertHistory(widget.film);
//       }
//   }
//
//   void simulateDownload() {
//     progress = 0.0;
//     downloadSubscription?.cancel();
//
//     downloadSubscription = Stream.periodic(Duration(milliseconds: 300)).listen((_) async {
//       setState(() {
//         progress += 0.1;
//       });
//
//       if (progress >= 1.0) {
//         setState(() {
//           progress = 1.0;
//         });
//         downloadSubscription?.cancel();
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Download selesai!')),
//         );
//
//         await DBHelper().insertDownload(widget.film);
//         Navigator.pop(context, true);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     downloadSubscription?.cancel();
//     _youtubeController.dispose(); // jangan lupa dispose player
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.film.title)),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             if (widget.film.videoUrl != null && widget.film.videoUrl!.isNotEmpty)
//               YoutubePlayer(
//                 controller: _youtubeController,
//                 showVideoProgressIndicator: true,
//                 progressIndicatorColor: Colors.red,
//               ),
//             SizedBox(height: 16),
//             Text('Genre: ${widget.film.genre}'),
//             Text('Rating: ⭐ ${widget.film.rating}'),
//             SizedBox(height: 20),
//             LinearProgressIndicator(value: progress),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: simulateDownload,
//               child: Text('Simulasi Download'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import '../models/film_model.dart';
// import 'dart:async';
// import '../data_repository/dbhelper.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'film_form_page.dart';  // pastikan import ini sudah ada
//
// class FilmDetailPage extends StatefulWidget {
//   final Film film;
//
//   const FilmDetailPage({Key? key, required this.film}) : super(key: key);
//
//   @override
//   _FilmDetailPageState createState() => _FilmDetailPageState();
// }
//
// class _FilmDetailPageState extends State<FilmDetailPage> {
//   double progress = 0.0;
//   StreamSubscription? downloadSubscription;
//   late YoutubePlayerController _youtubeController;
//   late Film film; // salin data film ke variabel lokal supaya bisa update
//
//   @override
//   void initState() {
//     super.initState();
//     film = widget.film;
//
//     final videoId = YoutubePlayer.convertUrlToId(film.videoUrl ?? '');
//     _youtubeController = YoutubePlayerController(
//       initialVideoId: videoId ?? '',
//       flags: YoutubePlayerFlags(
//         autoPlay: false,
//         mute: false,
//       ),
//     );
//     if (film.videoUrl != null && film.videoUrl!.isNotEmpty) {
//       DBHelper().insertHistory(film);
//     }
//   }
//
//   void simulateDownload() {
//     progress = 0.0;
//     downloadSubscription?.cancel();
//
//     downloadSubscription = Stream.periodic(Duration(milliseconds: 300)).listen((_) async {
//       setState(() {
//         progress += 0.1;
//       });
//
//       if (progress >= 1.0) {
//         setState(() {
//           progress = 1.0;
//         });
//         downloadSubscription?.cancel();
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Download selesai!')),
//         );
//
//         await DBHelper().insertDownload(film);
//         Navigator.pop(context, true);
//       }
//     });
//   }
//
//   Future<void> _deleteFilm() async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Hapus Film'),
//         content: Text('Apakah Anda yakin ingin menghapus film ini?'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Batal')),
//           TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Hapus')),
//         ],
//       ),
//     );
//
//     if (confirm == true) {
//       await DBHelper().deleteFilm(film.id!);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Film berhasil dihapus')),
//       );
//       Navigator.pop(context, true); // kembali ke halaman utama dengan tanda ada perubahan
//     }
//   }
//
//   Future<void> _updateFilm() async {
//     final updatedFilm = await Navigator.push<Film>(
//       context,
//       MaterialPageRoute(
//         builder: (_) => FilmFormPage(
//           film: film,
//           onSubmit: (Film newFilm) async {
//             // ini tidak dipakai langsung, karena kita tunggu hasil dari FilmFormPage via Navigator.pop
//           },
//         ),
//       ),
//     );
//
//     if (updatedFilm != null) {
//       await DBHelper().updateFilm(updatedFilm);
//       setState(() {
//         film = updatedFilm;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Film berhasil diperbarui')),
//       );
//       // tetap di halaman detail tapi data sudah update
//     }
//   }
//
//   @override
//   void dispose() {
//     downloadSubscription?.cancel();
//     _youtubeController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(film.title),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.edit),
//             tooltip: 'Edit Film',
//             onPressed: _updateFilm,
//           ),
//           IconButton(
//             icon: Icon(Icons.delete),
//             tooltip: 'Hapus Film',
//             onPressed: _deleteFilm,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             if (film.videoUrl != null && film.videoUrl!.isNotEmpty)
//               YoutubePlayer(
//                 controller: _youtubeController,
//                 showVideoProgressIndicator: true,
//                 progressIndicatorColor: Colors.red,
//               ),
//             SizedBox(height: 16),
//             Text('Genre: ${film.genre}'),
//             Text('Rating: ⭐ ${film.rating}'),
//             SizedBox(height: 20),
//             LinearProgressIndicator(value: progress),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: simulateDownload,
//               child: Text('Simulasi Download'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../models/film_model.dart';
import 'dart:async';
import '../data_repository/dbhelper.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'film_form_page.dart';

class FilmDetailPage extends StatefulWidget {
  final Film film;

  const FilmDetailPage({Key? key, required this.film}) : super(key: key);

  @override
  _FilmDetailPageState createState() => _FilmDetailPageState();
}

class _FilmDetailPageState extends State<FilmDetailPage> {
  double progress = 0.0;
  StreamSubscription? downloadSubscription;
  late YoutubePlayerController _youtubeController;
  late Film film;
  bool isDownloaded = false;

  @override
  void initState() {
    super.initState();
    film = widget.film;

    final videoId = YoutubePlayer.convertUrlToId(film.videoUrl ?? '');
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    if (film.videoUrl != null && film.videoUrl!.isNotEmpty) {
      DBHelper().insertHistory(film);
    }

    _checkIfDownloaded(); // cek apakah film sudah diunduh
  }

  Future<void> _checkIfDownloaded() async {
    final downloads = await DBHelper().getDownloads();
    setState(() {
      isDownloaded = downloads.any((f) => f.id == film.id);
    });
  }

  void simulateDownload() {
    progress = 0.0;
    downloadSubscription?.cancel();

    downloadSubscription =
        Stream.periodic(Duration(milliseconds: 300)).listen((_) async {
      setState(() {
        progress += 0.1;
      });

      if (progress >= 1.0) {
        setState(() {
          progress = 1.0;
        });
        downloadSubscription?.cancel();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download selesai!')),
        );

        await DBHelper().insertDownload(film);
        setState(() {
          isDownloaded = true; // disable tombol
        });
        Navigator.pop(context, true);
      }
    });
  }

  Future<void> _deleteFilm() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Film'),
        content: Text('Apakah Anda yakin ingin menghapus film ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Hapus')),
        ],
      ),
    );

    if (confirm == true) {
      await DBHelper().deleteFilm(film.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Film berhasil dihapus')),
      );
      Navigator.pop(context, true);
    }
  }

  Future<void> _updateFilm() async {
    final updatedFilm = await Navigator.push<Film>(
      context,
      MaterialPageRoute(
        builder: (_) => FilmFormPage(
          film: film,
          onSubmit: (_) {}, // tak terpakai di sini
        ),
      ),
    );

    if (updatedFilm != null) {
      await DBHelper().updateFilm(updatedFilm);
      setState(() {
        film = updatedFilm;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Film berhasil diperbarui')),
      );
    }
  }

  @override
  void dispose() {
    downloadSubscription?.cancel();
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(film.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: 'Edit Film',
            onPressed: _updateFilm,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Hapus Film',
            onPressed: _deleteFilm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (film.videoUrl != null && film.videoUrl!.isNotEmpty)
              YoutubePlayer(
                controller: _youtubeController,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.red,
              ),
            SizedBox(height: 16),
            Text('Genre: ${film.genre}'),
            Text('Rating: ⭐ ${film.rating}'),
            SizedBox(height: 20),
            LinearProgressIndicator(value: progress),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isDownloaded ? null : simulateDownload,
              child: Text('Simulasi Download'),
            ),
          ],
        ),
      ),
    );
  }
}

