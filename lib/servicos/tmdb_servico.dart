import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TMDBServico {
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _apiKey = dotenv.env['TMDB_API_KEY']!;

  Future<List<dynamic>> getMovies() async {
    final response = await http.get(
        Uri.parse('$_baseUrl/movie/popular?language=pt-br&api_key=$_apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Erro!');
    }
  }

  Future<List<dynamic>> searchMovies(String _term) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/search/movie?api_key=$_apiKey&query=$_term&language=pt-br'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Erro!');
    }
  }

  String obtemNomesGeneros(List<dynamic> genreIds) {
    const Map<int, String> genreMap = {
      28: "Ação",
      12: "Aventura",
      16: "Animação",
      35: "Comédia",
      80: "Crime",
      99: "Documentário",
      18: "Drama",
      10751: "Família",
      14: "Fantasia",
      36: "História",
      27: "Terror",
      10402: "Música",
      9648: "Mistério",
      10749: "Romance",
      878: "Ficção Científica",
      10770: "Filme de TV",
      53: "Thriller",
      10752: "Guerra",
      37: "Faroeste"
    };
    List<int> genreIdsInt = genreIds.map((id) => int.tryParse(id.toString()) ?? 0).toList();
    List<String> genreNames = genreIdsInt.map((id) => genreMap[id] ?? "Desconhecido").toList();
    return genreNames.join(", ");
  }
}
