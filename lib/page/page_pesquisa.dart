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
  }

  void _performSearch() {
    productStore.filterProducts(_searchController.text);
  }

  void _filterByPriceAscending() {
    productStore.filterByPriceAscending();
  }

  void _filterByPriceDescending() {
    productStore.filterByPriceDescending();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Pesquisar produto...',
                  hintStyle: TextStyle(color: Colors.pink[200]),
                  fillColor: Colors.pink[100],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: _performSearch,
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 241, 141, 174),
      ),
      backgroundColor: Colors.pink[50],
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _filterByPriceAscending,
                child: const Text('Menor Preço'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _filterByPriceDescending,
                child: const Text('Maior Preço'),
              ),
            ],
          ),
          Expanded(
            child: Observer(
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
                    return Container(
                      padding: const EdgeInsets.all(12.0),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(143, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'] ?? 'Nome não disponível',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            product['brand'] ?? 'Sem marca',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            'Preço: \$${product['price'] ?? '0.00'}',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
