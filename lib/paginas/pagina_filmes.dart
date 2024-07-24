import 'package:filmes/paginas/pagina_favoritos.dart';
import 'package:flutter/material.dart'; // Importa a biblioteca principal do Flutter para usar os widgets do Material Design.
import 'package:filmes/servicos/tmdb_service.dart'; // Importa o serviço que interage com a API do TMDB.
import 'pagina_detalhes_filme.dart'; // Importa a página de detalhes do filme.

class PaginaFilmes extends StatefulWidget {
  const PaginaFilmes({super.key});

  @override
  _PaginaFilmesState createState() =>
      _PaginaFilmesState(); // Cria o estado associado a este widget.
}

class _PaginaFilmesState extends State<PaginaFilmes> {
  late Future<List<dynamic>> _movies;
  final TMDBService _tmdbService = TMDBService();
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
      // final requestToken =  _tmdbService.getRequestToken();
      //  _tmdbService.createSession(requestToken);
      //  _tmdbService.getAccountId(requestToken);
      _movies = _tmdbService.fetchMovies();
  }


  // Função para mostrar os detalhes do filme ao clicar em um item da lista.
  void mostrarDetalhes(Map<String, dynamic> filme) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaginaDetalhesFilme(
            filme: filme), // Navega para a página de detalhes do filme.
      ),
    );
  }

  // Função para pesquisar filmes na API do TMDB.
  void _pesquisarFilmes(String query) {
    setState(() {
      _movies = _tmdbService.searchMovies(
          query); // Atualiza a lista de filmes com base na pesquisa.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filmelândia'), // Título da AppBar.
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(
              56.0), // Define a altura preferida do campo de pesquisa.
          child: Padding(
            padding: const EdgeInsets.all(
                8.0), // Adiciona padding ao redor do campo de pesquisa.
            child: TextField(
              decoration: InputDecoration(
                hintText:
                    'Pesquisar filmes...', // Texto de dica no campo de pesquisa.
                fillColor: Colors.white, // Cor de fundo do campo de pesquisa.
                filled: true,
                prefixIcon: const Icon(
                    Icons.search), // Ícone de pesquisa dentro do campo.
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      20.0), // Bordas arredondadas para o campo de pesquisa.
                ),
              ),
              onSubmitted:
                  _pesquisarFilmes, // Chama a função de pesquisa ao submeter o texto.
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future:
            _movies, // Constrói a interface com base no Future que carrega os filmes.
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
                    onTap: () => mostrarDetalhes(
                        movie), // Chama a função para mostrar os detalhes do filme.
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Filmes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Pesquisar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            showSearch(
              context: context,
              delegate: FilmeSearchDelegate(
                  _tmdbService), // Abre a barra de pesquisa ao clicar no item "Pesquisar".
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    PaginaFavoritos(), // Navega para a página de detalhes do filme.
              ),
            );
          }
        },
      ),
    );
  }
}

class FilmeSearchDelegate extends SearchDelegate {
  final TMDBService tmdbService; // Referência ao serviço TMDBService.

  FilmeSearchDelegate(this.tmdbService);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Limpa a query de pesquisa ao clicar no ícone de limpar.
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context,
            null); // Fecha a barra de pesquisa ao clicar no ícone de voltar.
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: tmdbService
          .searchMovies(query), // Faz a pesquisa de filmes com base na query.
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
          final movies = snapshot.data!; // Obtém a lista de filmes encontrados.
          return ListView.builder(
            itemCount: movies.length, // Define o número de itens na lista.
            itemBuilder: (context, index) {
              final movie = movies[index]; // Obtém o filme atual.
              return ListTile(
                leading: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie['poster_path']}', // Carrega a imagem do filme.
                  fit: BoxFit.cover,
                ),
                title: Text(movie['title']), // Exibe o título do filme.
                subtitle: Text(tmdbService.obterNomesGeneros(
                    movie['genre_ids'])), // Exibe os gêneros do filme.
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaginaDetalhesFilme(
                          filme:
                              movie), // Navega para a página de detalhes do filme.
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(); // Não exibe sugestões iniciais.
  }
}
