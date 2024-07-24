import 'package:filmes/paginas/pagina_detalhes_filme.dart';
import 'package:filmes/servicos/tmdb_servico.dart';
import 'package:flutter/material.dart';

class PaginaFilmes extends StatefulWidget {
  const PaginaFilmes({super.key});

  @override
  State<PaginaFilmes> createState() => _PaginaFilmesState();
}

class _PaginaFilmesState extends State<PaginaFilmes> {
  late Future<List<dynamic>> _movies;
  final TMDBServico _tmdbServico = TMDBServico();

  @override
  void initState() {
    super.initState();
    _movies = _tmdbServico
        .getMovies(); // Supondo que fetchMovies retorna uma Future<List<dynamic>>
  }

  void mostrarDetalhes(Map<String, dynamic> filme) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => PaginaDetalhesFilme(
        filme : filme,
      )
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: TextField(
          // controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Buscar filmes...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: TextStyle(color: Colors.white),
          // onSubmitted: (query) => _fetchMovies(query),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _movies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar filmes'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum filme encontrado'));
          } else {
            final filmes = snapshot.data!;
            return ListView.builder(
              itemCount: filmes.length,
              itemBuilder: (context, index) {
                final filme = filmes[index];
                return ListTile(
                  title: Text(filme['title']),
                  subtitle:
                      Text(_tmdbServico.obtemNomesGeneros(filme['genre_ids'])),
                  leading: filme['poster_path'] != null
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w200${filme['poster_path']}')
                      : Container(width: 50, height: 50, color: Colors.grey),       
                  onTap: () => mostrarDetalhes(filme),             
                );
              },
            );
          }
        },
      ),
    );
  }
}
