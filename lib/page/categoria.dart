import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../store/product_store.dart';
import './page_pesquisa.dart';

class Categoria extends StatefulWidget {
  const Categoria({super.key});

  @override
  _CategoriaState createState() => _CategoriaState();
}

class _CategoriaState extends State<Categoria> {
  final productStore = ProductStore();

  @override
  void initState() {
    super.initState();
    // Fetch products when the widget is initialized
    productStore.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
      ),
      body: Observer(
        builder: (_) {
          if (productStore.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Extrair as categorias únicas dos produtos
          final categories = productStore.products
              .map((product) => product.category)
              .where((category) => category != null)
              .toSet()
              .toList();

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                title: Text(category ?? 'Sem categoria'),
                onTap: () {
                  // Navegar para a tela de pesquisa e filtrar por categoria
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PagePesquisa(selectedCategory: category),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
