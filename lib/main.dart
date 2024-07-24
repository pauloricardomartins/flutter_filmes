import 'package:flutter/material.dart'; // Importa a biblioteca principal do Flutter para usar os widgets do Material Design.
import 'meu_aplicativo.dart'; // Importa o widget MeuAplicativo, que será o widget raiz do aplicativo.
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importa a biblioteca flutter_dotenv para carregar variáveis de ambiente de um arquivo .env.

void main() async {
  // Função principal que inicializa o aplicativo.
  
  await dotenv.load(fileName: ".env"); // Carrega as variáveis de ambiente do arquivo .env de forma assíncrona.
  
  runApp(const MeuAplicativo()); // Chama a função runApp para iniciar o aplicativo com o widget MeuAplicativo.
}
