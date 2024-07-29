import 'package:flutter/material.dart';

class PagePesquisa extends StatefulWidget {
  const PagePesquisa({super.key});

  @override
  State<PagePesquisa> createState() => _PagePesquisaState();
}

class _PagePesquisaState extends State<PagePesquisa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Pesquisar produto..',
            hintStyle: TextStyle(color: Colors.pink[200]), 
            fillColor: Colors.pink[100], 
            filled: true, 
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0), 
              borderSide: BorderSide.none, 
            ),
            suffixIcon: const Icon(
              Icons.search,
              color: Colors.white, 
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0), 
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 241, 141, 174), 
      ),
      backgroundColor: Colors.pink[50], 
      body: const Center(
        child: Text('Conteúdo da página'),
      ),
    );
  }
}
