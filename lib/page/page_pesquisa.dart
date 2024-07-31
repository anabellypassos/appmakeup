import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../store/product_store.dart';


class PagePesquisa extends StatefulWidget {
  const PagePesquisa({super.key});

  @override
  State<PagePesquisa> createState() => _PagePesquisaState();
}

class _PagePesquisaState extends State<PagePesquisa> {
  final productStore = ProductStore();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    productStore.fetchProducts();
    _searchController.addListener(() {
      productStore.filterProducts(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
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
      body: Observer(
        builder: (_) {
          if (productStore.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (productStore.filteredProducts.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado.'));
          }

          return ListView.builder(
            itemCount: productStore.filteredProducts.length,
            itemBuilder: (context, index) {
              final product = productStore.filteredProducts[index];
              return ListTile(
                title: Text(product['name']),
                subtitle: Text(product['brand'] ?? 'Sem marca'),
              );
            },
          );
        },
      ),
    );
  }
}