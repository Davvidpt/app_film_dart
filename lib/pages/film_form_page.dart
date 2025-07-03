import 'package:flutter/material.dart';
import '../models/film_model.dart';

class FilmFormPage extends StatefulWidget {
  final Film? film;
  final Function(Film) onSubmit;

  FilmFormPage({this.film, required this.onSubmit});

  @override
  _FilmFormPageState createState() => _FilmFormPageState();
}

class _FilmFormPageState extends State<FilmFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _ratingController = TextEditingController();
  final _videoUrlController = TextEditingController(); // Tambahan
  String _selectedGenre = 'Action';

  final genres = [ 'Action', 'Drama', 'Comedy', 'Horror','Slice of Life','Romance'];

  @override
  void initState() {
    super.initState();
    if (widget.film != null) {
      _titleController.text = widget.film!.title;
      _selectedGenre = widget.film!.genre;
      _ratingController.text = widget.film!.rating.toString();
      _videoUrlController.text = widget.film!.videoUrl ?? ''; // Tambahan
    }
  }

  void _saveFilm() {
    if (_formKey.currentState!.validate()) {
      final film = Film(
        id: widget.film?.id,
        title: _titleController.text,
        genre: _selectedGenre,
        rating: double.tryParse(_ratingController.text) ?? 0.0,
        videoUrl: _videoUrlController.text.isEmpty ? null : _videoUrlController.text,
      );
      widget.onSubmit(film);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _ratingController.dispose();
    _videoUrlController.dispose(); // dispose juga
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.film == null ? 'Tambah Film' : 'Edit Film')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Judul Film'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedGenre,
                decoration: InputDecoration(labelText: 'Genre'),
                items: genres.map((genre) => DropdownMenuItem(
                  value: genre,
                  child: Text(genre),
                )).toList(),
                onChanged: (value) => setState(() => _selectedGenre = value!),
              ),
              TextFormField(
                controller: _ratingController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Rating'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _videoUrlController,
                decoration: InputDecoration(labelText: 'Link YouTube (Opsional)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveFilm,
                child: Text(widget.film == null ? 'Simpan' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
