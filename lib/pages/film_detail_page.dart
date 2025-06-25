import 'package:flutter/material.dart';
import '../models/film_model.dart';
import 'dart:async';

class FilmDetailPage extends StatefulWidget {
  final Film film;
  FilmDetailPage({required this.film});

  @override
  _FilmDetailPageState createState() => _FilmDetailPageState();
}

class _FilmDetailPageState extends State<FilmDetailPage> {
  double progress = 0.0;
  StreamSubscription? downloadSubscription;  // simpan listener stream untuk cancel

  void simulateDownload() {
    progress = 0.0;

    // cancel jika sebelumnya ada simulasi berjalan
    downloadSubscription?.cancel();

    // listen stream periodik setiap 300ms
    downloadSubscription = Stream.periodic(Duration(milliseconds: 300)).listen((_) {
      setState(() {
        progress += 0.1;
        if (progress >= 1.0) {
          progress = 1.0;
          downloadSubscription?.cancel();  // stop simulasi download
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Download selesai!')),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    downloadSubscription?.cancel(); // pastikan cancel saat dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.film.title)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Genre: ${widget.film.genre}'),
            Text('Rating: ${widget.film.rating}'),
            SizedBox(height: 20),
            LinearProgressIndicator(value: progress),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: simulateDownload,
              child: Text('Simulasi Download'),
            ),
          ],
        ),
      ),
    );
  }
}
