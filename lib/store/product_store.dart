import 'package:mobx/mobx.dart';
import 'package:dio/dio.dart';

part 'product_store.g.dart';

class ProductStore = _ProductStore with _$ProductStore;

abstract class _ProductStore with Store {
  @observable
  ObservableList products = ObservableList();

  @observable
  ObservableList filteredProducts = ObservableList();

  @observable
  bool isLoading = false;

  @action
  Future<void> fetchProducts() async {
    isLoading = true;
    try {
      var response = await Dio().get('http://makeup-api.herokuapp.com/api/v1/products.json');
      products = ObservableList.of(response.data);
      filteredProducts = ObservableList.of(products); // Inicialmente, todos os produtos são filtrados
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      isLoading = false;
    }
  }

  @action
  void filterProducts(String query) {
    if (query.isEmpty) {
      filteredProducts = ObservableList.of(products);
      return;
    }

    final lowerQuery = query.toLowerCase();

    filteredProducts = ObservableList.of(
      products.where((product) {
        final productName = (product['name'] ?? '').toLowerCase();
        final productBrand = (product['brand'] ?? '').toLowerCase();
        final productTags = ((product['tags'] ?? []) as List).map((e) => e.toString().toLowerCase()).toList();
        final productCategory = (product['category'] ?? '').toLowerCase();

        // Verifica se qualquer uma das tags contém a consulta
        bool tagsMatch = productTags.any((tag) => tag.contains(lowerQuery));

        return productName.contains(lowerQuery) ||
               productBrand.contains(lowerQuery) ||
               tagsMatch ||
               productCategory.contains(lowerQuery);
      })
    );
  }

  @action
  void filterByPriceAscending() {
    filteredProducts.sort((a, b) {
      double priceA = double.tryParse(a['price']?.toString() ?? '0') ?? 0;
      double priceB = double.tryParse(b['price']?.toString() ?? '0') ?? 0;
      return priceA.compareTo(priceB);
    });
  }

  @action
  void filterByPriceDescending() {
    filteredProducts.sort((a, b) {
      double priceA = double.tryParse(a['price']?.toString() ?? '0') ?? 0;
      double priceB = double.tryParse(b['price']?.toString() ?? '0') ?? 0;
      return priceB.compareTo(priceA);
    });
  }
  @action
void resetFilter() {
  filteredProducts = ObservableList.of(products);
}

}
