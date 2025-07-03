
import 'package:flutter/material.dart';
import '../data_repository/dbhelper.dart';
import '../models/film_model.dart';
import 'film_detail_page.dart';
import 'history_page.dart';
import 'download_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'film_form_page.dart'; //


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBHelper dbHelper = DBHelper();
  String? selectedGenre = 'All Genre';
  List<String> genres = ['All Genre', 'Action', 'Drama', 'Comedy', 'Horror', 'Slice of Life', 'Romance'];
  late Future<List<Film>> films;

  @override
  void initState() {
    super.initState();
    _loadFilms();
  }

  void _loadFilms() {
    setState(() {
      films = selectedGenre == 'All Genre'
          ? dbHelper.getFilms()
          : dbHelper.getFilmsByGenre(selectedGenre!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('App FILM', style: TextStyle(letterSpacing: 1.5, color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: Text('Histori Tonton'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HistoryPage())),
            ),
            ListTile(
              title: Text('Downloads'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DownloadPage())),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButton<String>(
              dropdownColor: Colors.grey[900],
              value: selectedGenre,
              style: TextStyle(color: Colors.white),
              iconEnabledColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  selectedGenre = value;
                  _loadFilms();
                });
              },
              items: genres.map((String genre) {
                return DropdownMenuItem<String>(
                  value: genre,
                  child: Text(genre, style: TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Featured Movies',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Film>>(
              future: films,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                if (snapshot.hasError)
                  return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
                if (!snapshot.hasData || snapshot.data!.isEmpty)
                  return Center(child: Text('No films found', style: TextStyle(color: Colors.white)));

               return GridView.builder(
                 padding: const EdgeInsets.all(12),
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: 3,
                   mainAxisSpacing: 16,
                   crossAxisSpacing: 12,
                   childAspectRatio: 0.6,
                 ),
                 itemCount: snapshot.data!.length,
                 itemBuilder: (context, index) {
                   final film = snapshot.data![index];
                   final thumb = _thumbnail(film);
                   return GestureDetector(
                     onTap: () async {
                       final result = await Navigator.push(
                         context,
                         MaterialPageRoute(builder: (_) => FilmDetailPage(film: film)),
                       );
                       if (result == true) _loadFilms();
                     },
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Stack(
                           children: [
                             ClipRRect(
                               borderRadius: BorderRadius.circular(8),
                               child: thumb != null
                                   ? Image.network(
                                       thumb,
                                       fit: BoxFit.cover,
                                       width: double.infinity,
                                       height: 160,
                                     )
                                   : Container(
                                       width: double.infinity,
                                       height: 160,
                                       color: Colors.grey,
                                       child: Icon(Icons.movie, color: Colors.white, size: 50),
                                     ),
                             ),
                             Positioned(
                               top: 6,
                               left: 6,
                               child: Container(
                                 padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                 decoration: BoxDecoration(
                                   color: Colors.red,
                                   borderRadius: BorderRadius.circular(4),
                                 ),
                                 child: Text(
                                   'FEATURED',
                                   style: TextStyle(color: Colors.white, fontSize: 10),
                                 ),
                               ),
                             ),
                           ],
                         ),
                         SizedBox(height: 6),
                         Text(
                           film.title,
                           maxLines: 2,
                           overflow: TextOverflow.ellipsis,
                           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                         ),
                         SizedBox(height: 20),
                         Text(
                           '⭐ ${film.rating != null ? film.rating!.toStringAsFixed(1) : '-'}',
                           style: TextStyle(color: Colors.white70, fontSize: 12),
                         ),
                       ],
                     ),
                   );
                 },
               );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
        onPressed: () {
          // Bisa tambahkan fungsi tambah film jika perlu
          // misal navigasi ke FilmFormPage dengan film null
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FilmFormPage(
                onSubmit: (Film newFilm) async {
                  await dbHelper.insertFilm(newFilm);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Film berhasil ditambahkan')),
                  );
                  _loadFilms();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  String? _thumbnail(Film film) {
    if (film.videoUrl == null) return null;
    final id = YoutubePlayer.convertUrlToId(film.videoUrl!);
    return id != null ? 'https://img.youtube.com/vi/$id/0.jpg' : null;
  }
}


