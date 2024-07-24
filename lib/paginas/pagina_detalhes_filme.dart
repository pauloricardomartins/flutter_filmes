import 'package:flutter/material.dart'; // Importa a biblioteca principal do Flutter para usar os widgets do Material Design.
import 'package:filmes/servicos/tmdb_service.dart'; // Importa o serviço TMDBService para obter os nomes dos gêneros.

class PaginaDetalhesFilme extends StatelessWidget {
  // Variável final que armazena as informações do filme.
  // É passada como argumento ao criar a instância da página de detalhes do filme.
  final Map<String, dynamic> filme;

  // Construtor da classe que inicializa a variável 'filme' usando a sintaxe de parâmetros nomeados.
  const PaginaDetalhesFilme({super.key, required this.filme});

  @override
  Widget build(BuildContext context) {
    // Constrói a interface da página.
    return Scaffold(
      // Scaffold fornece uma estrutura visual básica para a aplicação, incluindo appBar, body, etc.
      appBar: AppBar(
        // AppBar exibe uma barra de aplicativos no topo da tela.
        title: Text(filme[
            'title']), // O título da AppBar é definido como o título do filme.
      ),
      body: SingleChildScrollView(
        // SingleChildScrollView permite que a tela seja rolada se o conteúdo for maior que a altura da tela.
        padding: const EdgeInsets.all(
            16.0), // Adiciona padding de 16 pixels ao redor do conteúdo.
        child: Column(
          // Column organiza os widgets em uma única coluna vertical.
          crossAxisAlignment: CrossAxisAlignment
              .start, // Alinha os widgets no início da coluna.
          children: [
            Center(
              // Center centraliza o widget filho.
              child: ClipRRect(
                // ClipRRect aplica bordas arredondadas ao widget filho.
                borderRadius: BorderRadius.circular(
                    8.0), // Define o raio das bordas como 8 pixels.
                child: Image.network(
                  // Image.network carrega uma imagem da internet.
                  'https://image.tmdb.org/t/p/w500${filme['poster_path']}', // URL da imagem do pôster do filme.
                  width: 200, // Largura da imagem.
                  height: 300, // Altura da imagem.
                  fit: BoxFit
                      .cover, // A imagem é redimensionada para cobrir a área definida.
                ),
              ),
            ),
            const SizedBox(
                height: 16), // Adiciona um espaço vertical de 16 pixels.
            Text(
              filme['title'], // Exibe o título do filme.
              style: const TextStyle(
                fontSize: 24, // Define o tamanho da fonte como 24 pixels.
                fontWeight:
                    FontWeight.bold, // Define o peso da fonte como negrito.
              ),
            ),
            const SizedBox(
                height: 8), // Adiciona um espaço vertical de 8 pixels.
            Text(
              'Gênero: ${TMDBService().obterNomesGeneros(filme['genre_ids'])}', // Obtém e exibe os nomes dos gêneros do filme
              style: const TextStyle(
                fontSize: 16, // Define o tamanho da fonte como 16 pixels.
                fontStyle:
                    FontStyle.italic, // Define o estilo da fonte como itálico.
              ),
            ),
            const SizedBox(
                height: 8), // Adiciona um espaço vertical de 8 pixels.
            Text(
              'Duração: ${filme['runtime'] ?? 'N/A'} minutos', // Exibe a duração do filme ou 'N/A' se não estiver disponível.
              style: const TextStyle(
                fontSize: 16, // Define o tamanho da fonte como 16 pixels.
              ),
            ),
            const SizedBox(
                height: 16), // Adiciona um espaço vertical de 16 pixels.
            Text(
              filme['overview'], // Exibe a sinopse do filme.
              style: const TextStyle(
                fontSize: 16, // Define o tamanho da fonte como 16 pixels.
              ),
            ),
          ],
        ),
      ),
    );
  }
}
