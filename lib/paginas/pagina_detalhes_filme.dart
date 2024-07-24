import 'package:filmes/servicos/tmdb_servico.dart';
import 'package:flutter/material.dart';

class PaginaDetalhesFilme extends StatelessWidget {
  final Map<String, dynamic> filme;

  const PaginaDetalhesFilme({super.key, required this.filme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(filme['title'], style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.indigo,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              if(filme['poster_path'] != null)
                Image.network('https://image.tmdb.org/t/p/w200${filme['poster_path']}'),
              const SizedBox(height: 16),
              Text(
                filme['title'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Gênero : ${TMDBServico().obtemNomesGeneros(filme['genre_ids'])}',
              ),
              const SizedBox(height: 8),
              Text(
                 filme['overview'],
                 style: TextStyle(fontSize: 14),
              ),                                            
            ],
          ),
        ));
  }
}
