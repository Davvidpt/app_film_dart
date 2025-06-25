import 'package:flutter/material.dart';
import '../data_repository/dbhelper.dart';
import '../models/film_model.dart';
import 'film_detail_page.dart';
import 'history_page.dart';// pastikan kamu sudah buat halaman histori
import 'download_page.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBHelper dbHelper = DBHelper();

  String? selectedGenre = 'All Genre';
  List<String> genres = ['All Genre', 'Action', 'Drama', 'Comedy', 'Horror'];

  late Future<List<Film>> films;

  @override
  void initState() {
    super.initState();
    films = dbHelper.getFilms();
  }

  void _loadFilms() {
    setState(() {
      if (selectedGenre == 'All Genre') {
        films = dbHelper.getFilms();
      } else {
        films = dbHelper.getFilmsByGenre(selectedGenre!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Film List'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: Text('Menu', style: TextStyle(color: Colors.black, fontSize: 24)),
            ),
            ListTile(
              title: Text('Histori Tonton'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryPage()),
                );
              },
            ),
            ListTile(
              title: Text('Downloads'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DownloadPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: selectedGenre,
              onChanged: (value) {
                setState(() {
                  selectedGenre = value;
                  _loadFilms();
                });
              },
              items: genres.map((String genre) {
                return DropdownMenuItem<String>(
                  value: genre,
                  child: Text(genre),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Film>>(
              future: films,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No films found'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final film = snapshot.data![index];
                      return ListTile(
                        title: Text(film.title),
                        subtitle: Text('${film.genre} - Rating: ${film.rating}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilmDetailPage(film: film),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
