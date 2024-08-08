import 'package:mobx/mobx.dart';
import 'package:dio/dio.dart';
//import '../models/autogenerated.dart'; 

part 'product_store.g.dart';

class ProductStore = _ProductStore with _$ProductStore;

abstract class _ProductStore with Store {
  @observable
  ObservableList<Autogenerated> products = ObservableList<Autogenerated>();

  @observable
  ObservableList<Autogenerated> filteredProducts = ObservableList<Autogenerated>();

  @observable
  bool isLoading = false;

  @action
  Future<void> fetchProducts() async {
    isLoading = true;
    try {
      var response = await Dio().get('http://makeup-api.herokuapp.com/api/v1/products.json');
      products = ObservableList.of((response.data as List).map((item) => Autogenerated.fromJson(item)).toList());
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
        final productName = product.name?.toLowerCase() ?? '';
        final productBrand = product.brand?.toLowerCase() ?? '';
        final productTags = product.tagList?.map((e) => e.toString().toLowerCase()).toList() ?? [];
        final productCategory = product.category?.toLowerCase() ?? '';

        bool tagsMatch = productTags.any((tag) => tag.contains(lowerQuery));

        return productName.contains(lowerQuery) ||
               productBrand.contains(lowerQuery) ||
               tagsMatch ||
               productCategory.contains(lowerQuery);
      }).toList()
    );
  }

  @action
  void filterByPriceAscending() {
    filteredProducts.sort((a, b) {
      double priceA = double.tryParse(a.price?.toString() ?? '0') ?? 0;
      double priceB = double.tryParse(b.price?.toString() ?? '0') ?? 0;
      return priceA.compareTo(priceB);
    });
  }

  @action
  void filterByPriceDescending() {
    filteredProducts.sort((a, b) {
      double priceA = double.tryParse(a.price?.toString() ?? '0') ?? 0;
      double priceB = double.tryParse(b.price?.toString() ?? '0') ?? 0;
      return priceB.compareTo(priceA);
    });
  }

  @action
  void resetFilter() {
    filteredProducts = ObservableList.of(products);
  }
  @action
void filterByBrand(String brand) {
  filteredProducts = ObservableList.of(
    products.where((product) => product.brand?.toLowerCase() == brand.toLowerCase()).toList(),
  );
}
@action
void filterByCategory(String category) {
  filteredProducts = ObservableList.of(
    products.where((product) => product.category?.toLowerCase() == category.toLowerCase()).toList(),
  );

} 
@action
void filterByTag(String tag) {
  filteredProducts = ObservableList.of(
    products.where((product) => product.tagList?.contains(tag) ?? false).toList(),
  );
}


}

class Autogenerated {
  int? id;
  String? brand;
  String? name;
  String? price;
  String? priceSign;
  String? currency;
  String? imageLink;
  String? productLink;
  String? websiteLink;
  String? description;
  double? rating;
  String? category;
  String? productType;
  List<String>? tagList;
  String? createdAt;
  String? updatedAt;
  String? productApiUrl;
  String? apiFeaturedImage;
  List<ProductColors>? productColors;

  Autogenerated(
      {this.id,
      this.brand,
      this.name,
      this.price,
      this.priceSign,
      this.currency,
      this.imageLink,
      this.productLink,
      this.websiteLink,
      this.description,
      this.rating,
      this.category,
      this.productType,
      this.tagList,
      this.createdAt,
      this.updatedAt,
      this.productApiUrl,
      this.apiFeaturedImage,
      this.productColors});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brand = json['brand'];
    name = json['name'];
    price = json['price'];
    priceSign = json['price_sign'];
    currency = json['currency'];
    imageLink = json['image_link'];
    productLink = json['product_link'];
    websiteLink = json['website_link'];
    description = json['description'];
    rating = json['rating']?.toDouble(); // Convertendo para double
    category = json['category'];
    productType = json['product_type'];
    tagList = json['tag_list'].cast<String>();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productApiUrl = json['product_api_url'];
    apiFeaturedImage = json['api_featured_image'];
    if (json['product_colors'] != null) {
      productColors = <ProductColors>[];
      json['product_colors'].forEach((v) {
        productColors!.add(ProductColors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['brand'] = brand;
    data['name'] = name;
    data['price'] = price;
    data['price_sign'] = priceSign;
    data['currency'] = currency;
    data['image_link'] = imageLink;
    data['product_link'] = productLink;
    data['website_link'] = websiteLink;
    data['description'] = description;
    data['rating'] = rating;
    data['category'] = category;
    data['product_type'] = productType;
    data['tag_list'] = tagList;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['product_api_url'] = productApiUrl;
    data['api_featured_image'] = apiFeaturedImage;
    if (productColors != null) {
      data['product_colors'] =
          productColors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductColors {
  String? hexValue;
  String? colourName;

  ProductColors({this.hexValue, this.colourName});

  ProductColors.fromJson(Map<String, dynamic> json) {
    hexValue = json['hex_value'];
    colourName = json['colour_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hex_value'] = hexValue;
    data['colour_name'] = colourName;
    return data;
  }
}
