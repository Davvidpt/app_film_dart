import 'package:flutter/material.dart';
import '../models/film_model.dart';
import '../data_repository/dbhelper.dart';
import 'film_detail_page.dart';

class FilmListPage extends StatelessWidget {
  final DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final String genre = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text('Genre: $genre')),
      body: FutureBuilder<List<Film>>(
        future: dbHelper.getFilms(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final films = snapshot.data!.where((film) => film.genre == genre).toList();
            return ListView.builder(
              itemCount: films.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(films[index].title),
                  subtitle: Text('Rating: ${films[index].rating}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilmDetailPage(film: films[index]),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading films.'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}