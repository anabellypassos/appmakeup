// product_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../store/product_store.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final productStore = ProductStore();

  @override
  void initState() {
    super.initState();
    productStore.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
      ),
      body: Observer(
        builder: (_) {
          if (productStore.isLoading) {
            return const Center(child:  CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: productStore.products.length,
            itemBuilder: (context, index) {
              final product = productStore.products[index];
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
