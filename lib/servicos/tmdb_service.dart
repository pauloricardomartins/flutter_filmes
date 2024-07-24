import 'dart:convert'; // Importa a biblioteca para manipulação de JSON.
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importa a biblioteca para carregar variáveis de ambiente.
import 'package:http/http.dart'
    as http; // Importa a biblioteca HTTP para fazer requisições web.

class TMDBService {
  // Define a URL base da API do TMDB.
  final String _baseUrl = 'https://api.themoviedb.org/3';
  // Obtém a chave da API do TMDB das variáveis de ambiente.
  // O operador ! é o operador de nulidade em Dart. Ele é usado para indicar que o valor acessado não será nulo.
  final String _apiKey = dotenv.env['TMDB_API_KEY']!;

  String? _sessionId;
  String? _accountId;
  
  // Método assíncrono para buscar filmes populares.
  /*
  Um Future em Dart é um objeto que representa uma operação assíncrona. 
  Ele pode ser pensado como uma promessa de que uma operação será completada no futuro. 
  O Future pode ter três estados: não concluído, concluído com sucesso, ou concluído com erro.
  A declaração Future<List<dynamic>> indica que esta função retornará um Future que, quando concluído, 
  resultará em uma lista (List) de objetos de tipo dinâmico (dynamic).
  */

  Future<String> getRequestToken() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/authentication/token/new?api_key=$_apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['request_token'];
    } else {
      throw Exception('Erro ao obter token de requisição');
    }
  }

Future<void> createSession(String requestToken) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/authentication/session/new?api_key=$_apiKey'),
      body: json.encode({'request_token': requestToken}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _sessionId = data['session_id'];
    } else {
      throw Exception('Erro ao criar sessão');
    }
  }

  Future<String> getAccountId(String sessionId) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/3/account?api_key=$_apiKey&session_id=$sessionId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['id'].toString();
    } else {
      throw Exception('Erro ao obter detalhes da conta');
    }
  }

  Future<List<dynamic>> listFavorites() async {
    if (_accountId == null) throw Exception('ID da conta não disponível');
    // Faz uma requisição GET para a API do TMDB.
    final response = await http.get(Uri.parse(
        '$_baseUrl/account/$_accountId/favorite/movies?api_key=$_apiKey&language=pt-BR'));

    // Verifica se a requisição foi bem-sucedida.
    if (response.statusCode == 200) {
      // Decodifica o corpo da resposta JSON.
      final data = json.decode(response.body);
      // Retorna a lista de filmes.
      return data['results'];
    } else {
      // Lança uma exceção se a requisição falhar.
      throw Exception('Erro ao carregar o favoritos');
    }
  }

  Future<List<dynamic>> fetchMovies() async {
    // Faz uma requisição GET para a API do TMDB.
    final response = await http.get(
        Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&language=pt-BR'));

    // Verifica se a requisição foi bem-sucedida.
    if (response.statusCode == 200) {
      // Decodifica o corpo da resposta JSON.
      final data = json.decode(response.body);
      // Retorna a lista de filmes.
      return data['results'];
    } else {
      // Lança uma exceção se a requisição falhar.
      throw Exception('Erro ao carregar o filme');
    }
  }

  // Método assíncrono para buscar filmes com base em uma query de pesquisa.
  Future<List<dynamic>> searchMovies(String query) async {
    // Faz uma requisição GET para a API do TMDB com a query de pesquisa.
    if (query == '') {
      return fetchMovies();
    }

    final response = await http.get(Uri.parse(
        '$_baseUrl/search/movie?api_key=$_apiKey&query=$query&language=pt-BR'));

    // Verifica se a requisição foi bem-sucedida.
    if (response.statusCode == 200) {
      // Decodifica o corpo da resposta JSON.
      final data = json.decode(response.body);
      // Retorna a lista de filmes encontrados.
      return data['results'];
    } else {
      // Lança uma exceção se a requisição falhar.
      throw Exception('Erro ao carregar o filme');
    }
  }

  // Método para obter os nomes dos gêneros a partir dos IDs dos gêneros.
  String obterNomesGeneros(List<dynamic> genreIds) {
    // Mapa de IDs de gêneros para nomes de gêneros.
    const Map<int, String> genreMap = {
      28: 'Ação',
      12: 'Aventura',
      16: 'Animação',
      35: 'Comédia',
      80: 'Crime',
      99: 'Documentário',
      18: 'Drama',
      10751: 'Família',
      14: 'Fantasia',
      36: 'História',
      27: 'Terror',
      10402: 'Música',
      9648: 'Mistério',
      10749: 'Romance',
      878: 'Ficção Científica',
      10770: 'Cinema TV',
      53: 'Thriller',
      10752: 'Guerra',
      37: 'Faroeste',
    };

    // Converte os IDs dos gêneros para inteiros.
    List<int> genreIdsInt =
        genreIds.map((id) => int.tryParse(id.toString()) ?? 0).toList();
    // Mapeia os IDs para os nomes dos gêneros.
    List<String> genreNames =
        genreIdsInt.map((id) => genreMap[id] ?? 'Desconhecido').toList();
    // Retorna os nomes dos gêneros como uma string separada por vírgulas.
    return genreNames.join(', ');
  }
}
