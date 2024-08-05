// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProductStore on _ProductStore, Store {
  late final _$productsAtom =
      Atom(name: '_ProductStore.products', context: context);

  @override
  ObservableList<dynamic> get products {
    _$productsAtom.reportRead();
    return super.products;
  }

  @override
  set products(ObservableList<dynamic> value) {
    _$productsAtom.reportWrite(value, super.products, () {
      super.products = value;
    });
  }

  late final _$filteredProductsAtom =
      Atom(name: '_ProductStore.filteredProducts', context: context);

  @override
  ObservableList<dynamic> get filteredProducts {
    _$filteredProductsAtom.reportRead();
    return super.filteredProducts;
  }

  @override
  set filteredProducts(ObservableList<dynamic> value) {
    _$filteredProductsAtom.reportWrite(value, super.filteredProducts, () {
      super.filteredProducts = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_ProductStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$fetchProductsAsyncAction =
      AsyncAction('_ProductStore.fetchProducts', context: context);

  @override
  Future<void> fetchProducts() {
    return _$fetchProductsAsyncAction.run(() => super.fetchProducts());
  }

  late final _$_ProductStoreActionController =
      ActionController(name: '_ProductStore', context: context);

  @override
  void filterProducts(String query) {
    final _$actionInfo = _$_ProductStoreActionController.startAction(
        name: '_ProductStore.filterProducts');
    try {
      return super.filterProducts(query);
    } finally {
      _$_ProductStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void filterByPriceAscending() {
    final _$actionInfo = _$_ProductStoreActionController.startAction(
        name: '_ProductStore.filterByPriceAscending');
    try {
      return super.filterByPriceAscending();
    } finally {
      _$_ProductStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void filterByPriceDescending() {
    final _$actionInfo = _$_ProductStoreActionController.startAction(
        name: '_ProductStore.filterByPriceDescending');
    try {
      return super.filterByPriceDescending();
    } finally {
      _$_ProductStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetFilter() {
    final _$actionInfo = _$_ProductStoreActionController.startAction(
        name: '_ProductStore.resetFilter');
    try {
      return super.resetFilter();
    } finally {
      _$_ProductStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
products: ${products},
filteredProducts: ${filteredProducts},
isLoading: ${isLoading}
    ''';
  }
}
