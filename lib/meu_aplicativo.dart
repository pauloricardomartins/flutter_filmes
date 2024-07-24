import 'package:flutter/material.dart'; // Importa a biblioteca principal do Flutter para usar os widgets do Material Design.
import 'paginas/pagina_filmes.dart'; // Importa o widget PaginaFilmes, que será a tela inicial do aplicativo.

class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo(
      {super.key}); // Construtor da classe MeuAplicativo. Utiliza a palavra-chave const para criar uma instância imutável da classe.

  @override
  Widget build(BuildContext context) {
    // O método build constrói a interface do widget.
    return MaterialApp(
      title: 'Filmes', // Define o título do aplicativo.
      debugShowCheckedModeBanner:
          false, // Remove a faixa de debug que aparece no canto superior direito.
      theme: ThemeData(
        primarySwatch:
            Colors.indigo, // Define a cor principal do tema como índigo.
        appBarTheme: const AppBarTheme(
          backgroundColor:
              Colors.indigo, // Define a cor de fundo da AppBar como índigo.
          foregroundColor: Colors
              .white, // Define a cor do texto e dos ícones na AppBar como branco.
          centerTitle: true, // Centraliza o título na AppBar.
          titleTextStyle: TextStyle(
            fontFamily: 'Roboto', // Define a fonte do título como Roboto.
            fontSize: 20, // Define o tamanho da fonte do título como 20.
            fontWeight:
                FontWeight.bold, // Define a fonte do título como negrito.
            color: Colors.white, // Define a cor da fonte do título como branco.
            letterSpacing: 2.0, // Define o espaçamento entre letras como 2.0.
          ),
        ),
      ),
      home:
          const PaginaFilmes(), // Define o widget inicial do aplicativo como PaginaFilmes.
    );
  }
}
