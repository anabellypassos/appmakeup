import 'package:flutter/material.dart';
import 'marca.dart'; // Certifique-se de que o caminho para o arquivo marca.dart está correto.
import 'categoria.dart';
import 'tags.dart';
class PaginaCategorias extends StatelessWidget {
  const PaginaCategorias({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            ' Category',      
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 226, 116, 193),
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Colors.white,
      ),
     body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Marca()), // Navega para a página Marca
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0), // Define o arredondamento das bordas
                child: Image.asset(
                  'assets/image/Marca.png', // Substitua o caminho se necessário
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>const Categoria()), // Navega para a página Marca
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0), // Define o arredondamento das bordas
                child: Image.asset(
                  'assets/image/ProductCategory.png', // Substitua o caminho se necessário
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
                  Container(
            margin: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>const Tags()), // Navega para a página Marca
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0), // Define o arredondamento das bordas
                child: Image.asset(
                  'assets/image/tag.png', // Substitua o caminho se necessário
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Adicione outros widgets aqui, se necessário
        ],
        
      ),
    );
  }
}