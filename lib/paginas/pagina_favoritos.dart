import 'package:filmes/servicos/tmdb_service.dart';
import 'package:flutter/material.dart';

class PaginaFavoritos extends StatefulWidget {
  const PaginaFavoritos({super.key});

  @override
  State<PaginaFavoritos> createState() => _PaginaFavoritosState();
}

class _PaginaFavoritosState extends State<PaginaFavoritos> {
    late Future<List<dynamic>>
      _favoritos; // Declaração da variável que vai armazenar o Future com a lista de filmes.
  final TMDBService _tmdbService =
      TMDBService(); // Instancia o serviço do TMDB.

  @override
  void initState() {
    super.initState();
    _favoritos = _tmdbService
        .listFavorites(); // Carrega os filmes populares na inicialização do estado.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold fornece uma estrutura visual básica para a aplicação, incluindo appBar, body, etc.
      appBar: AppBar(
        // AppBar exibe uma barra de aplicativos no topo da tela.
        title: Text(
            'Favoritos'), // O título da AppBar é definido como o título do filme.
      ),
        body: FutureBuilder<List<dynamic>>(
        future:
            _favoritos, // Constrói a interface com base no Future que carrega os filmes.
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Mostra um indicador de progresso enquanto carrega.
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    'Error: ${snapshot.error}')); // Mostra uma mensagem de erro se ocorrer um erro.
          } else {
            final movies = snapshot.data!; // Obtém a lista de filmes.
            return ListView.builder(
              itemCount: movies.length, // Define o número de itens na lista.
              itemBuilder: (context, index) {
                final movie = movies[index]; // Obtém o filme atual.
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        12), // Define bordas arredondadas para os cards.
                  ),
                  elevation: 5, // Define a elevação dos cards.
                  margin: const EdgeInsets.symmetric(
                      vertical: 8), // Adiciona margem vertical entre os cards.
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(
                        16), // Adiciona padding dentro do ListTile.
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          8), // Bordas arredondadas para a imagem do filme.
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${movie['poster_path']}', // Carrega a imagem do filme.
                        width: 50,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      movie['title'], // Exibe o título do filme.
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _tmdbService.obterNomesGeneros(
                              movie['genre_ids']), // Exibe os gêneros do filme.
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                            'Min: ${movie['runtime'] ?? 'N/A'}'), // Exibe a duração do filme.
                      ],
                    ),
                    trailing: Icon(Icons.play_arrow,
                        color: Colors.indigo), // Ícone de play.
                    selected: true,
                    // selectedTileColor: Colors.blue[50],
                
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
