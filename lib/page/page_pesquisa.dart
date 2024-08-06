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
  String _selectedSortOption = 'Ordenar por';

  @override
  void initState() {
    super.initState();
    productStore.fetchProducts();
    _searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    _searchController.removeListener(_performSearch);
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    productStore.filterProducts(_searchController.text);
  }

  void _handleSortOptionChange(String? newValue) {
    setState(() {
      _selectedSortOption = newValue ?? 'Ordenar por';
      switch (_selectedSortOption) {
        case 'Menor Preço':
          productStore.filterByPriceAscending();
          break;
        case 'Maior Preço':
          productStore.filterByPriceDescending();
          break;
        case 'Reverter':
          productStore.resetFilter();
          break;
        default:
          break;
      }
    });
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: _selectedSortOption,
              onChanged: _handleSortOptionChange,
              items: <String>[
                'Ordenar por',
                'Menor Preço',
                'Maior Preço',
                'Reverter'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              dropdownColor: Colors.pink[100],
              icon: Icon(Icons.arrow_drop_down, color: Colors.pink[300]),
            ),
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

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Número de colunas
                    crossAxisSpacing: 10.0, // Espaçamento horizontal entre os cards
                    mainAxisSpacing: 10.0, // Espaçamento vertical entre os cards
                    childAspectRatio: 0.7, // Proporção do tamanho dos cards
                  ),
                  itemCount: productStore.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = productStore.filteredProducts[index];

                    return Container(
                      margin: const EdgeInsets.all(10.0), // Margem ao redor do card
                      child: Card(
                        elevation: 4, // Adiciona uma leve elevação ao card
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.imageLink != null)
                                Center(
                                  child: Image.network(
                                    product.imageLink!,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: progress.expectedTotalBytes != null
                                                ? progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1)
                                                : null,
                                          ),
                                        );
                                      }
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          size: 120,
                                          color: Colors.grey[400],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              const SizedBox(height: 8.0),
                              Text(
                                product.name ?? 'Nome não disponível',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                product.brand ?? 'Sem marca',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                product.price != null
                                    ? 'Preço: \$${product.price}'
                                    : 'Preço não disponível',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
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
