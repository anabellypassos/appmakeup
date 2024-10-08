import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../store/product_store.dart';
import './page_pesquisa.dart';

class Tags extends StatefulWidget {
  const Tags({super.key});

  @override
  _TagsState createState() => _TagsState();
}

class _TagsState extends State<Tags> {
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
        title: const Text('Tags'),
      ),
      body: Observer(
        builder: (_) {
          if (productStore.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Extrair as tags únicas dos produtos
          final tags = productStore.products
              .expand((product) => product.tagList ?? [])
              .toSet()
              .toList();

          return ListView.builder(
            itemCount: tags.length,
            itemBuilder: (context, index) {
              final tag = tags[index];
              return ListTile(
                title: Text(tag),
                onTap: () {
                  // Navegar para a tela de pesquisa e filtrar por tag
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PagePesquisa(selectedTag: tag),
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
