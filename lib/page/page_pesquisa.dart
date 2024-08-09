import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../store/product_store.dart';
import './pagina_categorias.dart';
import '../page/info_produtos.dart';

class PagePesquisa extends StatefulWidget {
  final String? selectedBrand;
  final String? selectedCategory;
  final String? selectedTag;

  const PagePesquisa({super.key, this.selectedBrand, this.selectedCategory, this.selectedTag});

  @override
  State<PagePesquisa> createState() => _PagePesquisaState();
}

class _PagePesquisaState extends State<PagePesquisa> {
  final productStore = ProductStore();
  final TextEditingController _searchController = TextEditingController();
  String _selectedSortOption = 'Sort by';
  int _selectedIndex = 1; // Índice do menu inferior ativo

  @override
  void initState() {
    super.initState();
    productStore.fetchProducts().then((_) {
      if (widget.selectedBrand != null) {
        productStore.filterByBrand(widget.selectedBrand!);
      } else if (widget.selectedCategory != null) {
        productStore.filterByCategory(widget.selectedCategory!);
      } else if (widget.selectedTag != null) {
        productStore.filterByTag(widget.selectedTag!);
      }
    });
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
      _selectedSortOption = newValue ?? 'Sort by';
      switch (_selectedSortOption) {
        case 'Lowest Price':
          productStore.filterByPriceAscending();
          break;
        case 'Highest Price':
          productStore.filterByPriceDescending();
          break;
        case 'Reset':
          productStore.resetFilter();
          break;
        default:
          break;
      }
    });
  }

  void _onBottomNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Navegar para a página Home, se necessário
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        // Já estamos na tela de pesquisa, não é necessário navegar
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PaginaCategorias()),
        );
        break;
      case 3:
        // Navegar para a tela de perfil, se necessário
        Navigator.pushNamed(context, '/perfil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(
              child: Row(
                children: [
                  Text(
                    'Glam Guru',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.pink,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'search',
                  hintStyle: TextStyle(color: Colors.pink[200]),
                  fillColor: Colors.pink[100],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Color.fromARGB(255, 240, 98, 146)),
              onPressed: _performSearch,
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 253, 253, 253),
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
                'Sort by',
                'Lowest Price',
                'Highest Price',
                'Reset'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              dropdownColor: Colors.pink[100],
              icon: const Icon(Icons.arrow_drop_down, color: Color.fromARGB(255, 240, 98, 146)),
            ),
          ),
          Expanded(
            child: Observer(
              builder: (_) {
                if (productStore.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (productStore.filteredProducts.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }

                return ListView.builder(
                  itemCount: productStore.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = productStore.filteredProducts[index];
                    final price = double.tryParse(product.price ?? '0.0') ?? 0.0;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InfoProduto(product: product),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (product.imageLink != null)
                                  Center(
                                    child: Image.network(
                                      product.imageLink!,
                                      height: 180,
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
                                            size: 180,
                                            color: Colors.grey[400],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                const SizedBox(height: 12.0),
                                Text(
                                  product.name ?? 'Name not available',
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  product.brand ?? 'Unbranded',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'R\$ ${price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink,
                                  ),
                                ),
                              ],
                            ),
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
       bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color.fromARGB(255, 240, 98, 146)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category, color: Color.fromARGB(255, 240, 98, 146)),
            label: 'Categories',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              // Navegar para a página Home, se necessário
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaginaCategorias()),
              );
              break;
          }
        },
      ),
    );
  }
}
