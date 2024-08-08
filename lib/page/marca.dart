import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../store/product_store.dart';
import 'page_pesquisa.dart';

class Marca extends StatefulWidget {
  const Marca({super.key});

  @override
  _MarcaState createState() => _MarcaState();
}

class _MarcaState extends State<Marca> {
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
        title: const Text('Marcas'),
      ),
      body: Observer(
        builder: (_) {
          if (productStore.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Extrair as marcas únicas dos produtos
          final brands = productStore.products
              .map((product) => product.brand)
              .where((brand) => brand != null)
              .toSet()
              .toList();

          return ListView.builder(
            itemCount: brands.length,
            itemBuilder: (context, index) {
              final brand = brands[index];
              return ListTile(
                title: Text(brand ?? 'Sem marca'),
                onTap: () {
                  // Navegar para a tela de pesquisa e filtrar por marca
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PagePesquisa(selectedBrand: brand),
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
