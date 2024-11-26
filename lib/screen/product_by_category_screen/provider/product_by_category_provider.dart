import '../../../../models/brand.dart';
import '../../../../models/category.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/data/data_provider.dart';
import '../../../../models/product.dart';
import '../../../../models/sub_category.dart';

class ProductByCategoryProvider extends ChangeNotifier {
  final DataProvider _dataProvider;
  Category? mySelectedCategory;
  SubCategory? mySelectedSubCategory;
  List<SubCategory> subCategories = [];
  List<Brand> brands = [];
  List<Brand> selectedBrands = [];
  List<Product> filteredProduct = [];

  ProductByCategoryProvider(this._dataProvider);

  filterInitialProductAndSubCategory(Category selectedCategory) {
    mySelectedSubCategory = SubCategory(name: 'All');
    mySelectedCategory = selectedCategory;
    subCategories = _dataProvider.subCategories
        .where((element) => element.categoryId?.sId == selectedCategory.sId)
        .toList();
    subCategories.insert(0, SubCategory(name: 'All'));
    filteredProduct = _dataProvider.products
        .where(
            (element) => element.proCategoryId?.name == selectedCategory.name)
        .toList();
    notifyListeners();
  }

  filterProductBySubCategory(SubCategory subCategory) {
    mySelectedSubCategory = subCategory;
    if (subCategory.name?.toLowerCase() == Category(name: 'All')) {
      filteredProduct = _dataProvider.products
          .where((element) =>
              element.proSubCategoryId?.name == mySelectedSubCategory?.name)
          .toList();
      //TODO: whatBrands
      brands = [];
    } else {
      filteredProduct = _dataProvider.products
          .where((element) =>
              element.proSubCategoryId?.name?.toLowerCase() ==
              subCategory.name?.toLowerCase())
          .toList();
      brands = _dataProvider.brands
          .where((element) => element.subcategoryId?.sId == subCategory.sId)
          .toList();
    }
    notifyListeners();
  }

  //无参数！
  filterProductByBrand(List<Brand> val) {
    if (selectedBrands.isEmpty) {
      filteredProduct = _dataProvider.products
          .where((element) =>
              element.proSubCategoryId?.name?.toLowerCase() ==
              mySelectedSubCategory?.name?.toLowerCase())
          .toList();
    } else {
      filteredProduct = _dataProvider.products
          .where((product) =>
              product.proSubCategoryId?.name == mySelectedSubCategory?.name &&
              selectedBrands
                  .any((brand) => product.proBrandId?.sId == brand.sId))
          .toList();
    }
    notifyListeners();
  }

  void sortProducts(bool ascending) {
    filteredProduct.sort((a, b) {
      if (ascending) {
        return a.price!.compareTo(b.price ?? 0);
      } else {
        return b.price!.compareTo(a.price ?? 0);
      }
    });
    notifyListeners();
  }

  void updateUI() {
    notifyListeners();
  }
}
