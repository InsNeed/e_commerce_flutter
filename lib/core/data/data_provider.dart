import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import '../../../../models/category.dart';
import '../../../models/api_response.dart';
import '../../../models/brand.dart';
import '../../../models/order.dart';
import '../../../models/poster.dart';
import '../../../models/product.dart';
import '../../../models/sub_category.dart';
import '../../../models/user.dart';
import '../../../services/http_services.dart';
import '../../../utility/snack_bar_helper.dart';

class DataProvider extends ChangeNotifier {
  HttpService service = HttpService();

  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  List<Category> get categories => _filteredCategories;

  List<SubCategory> _allSubCategories = [];
  List<SubCategory> _filteredSubCategories = [];

  List<SubCategory> get subCategories => _filteredSubCategories;

  List<Brand> _allBrands = [];
  List<Brand> _filteredBrands = [];
  List<Brand> get brands => _filteredBrands;

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _allProducts;

  List<Poster> _allPosters = [];
  List<Poster> _filteredPosters = [];
  List<Poster> get posters => _filteredPosters;

  List<Order> _allOrders = [];
  List<Order> _filteredOrders = [];
  List<Order> get orders => _filteredOrders;

  DataProvider() {
    getAllCategory();
    getAllSubCategory();
    getAllBrands();
    getAllProducts();
    getAllPosters();
  }

  Future<List<Category>> getAllCategory({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'categories');
      if (response.isOk) {
        ApiResponse<List<Category>> apiResponse =
            ApiResponse<List<Category>>.fromJson(
          response.body,
          (json) =>
              (json as List).map((item) => Category.fromJson(item)).toList(),
        );
        _allCategories = apiResponse.data ?? [];
        _filteredCategories = List.from(_allCategories);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _filteredCategories;
  }

  void filterCategories(String keyword) {
    if (keyword.isEmpty) {
      _filteredCategories = List.from(_allCategories);
      notifyListeners();
    } else {
      final lowerKeyword = keyword.toLowerCase();
      //可以悬指针于where查看其参数：返回值为bool 的 函数
      _filteredCategories = _allCategories.where((category) {
        return (category.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
      notifyListeners();
    }
  }

  Future<List<SubCategory>> getAllSubCategory(
      {bool showSnackBar = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'subCategories');
      if (response.isOk) {
        ApiResponse<List<SubCategory>> apiResponse =
            ApiResponse<List<SubCategory>>.fromJson(
          response.body,
          //将json转List, map()=> SubCategory的Fromjson得到的List
          (json) =>
              (json as List).map((item) => SubCategory.fromJson(item)).toList(),
        );
        _allSubCategories = apiResponse.data ?? [];
        _filteredSubCategories = List.from(_allSubCategories);
        notifyListeners();
        if (showSnackBar == true) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
        }
      }
    } catch (e) {
      print(e);
      if (showSnackBar == false) {
        SnackBarHelper.showSuccessSnackBar(e.toString());
      }
      rethrow;
    }
    return _filteredSubCategories;
  }

  void filterSubCategories(String keyword) {
    if (keyword.isEmpty) {
      _filteredSubCategories = List.from(_allSubCategories);
      notifyListeners();
    } else {
      final lowerKeyword = keyword.toLowerCase();
      //可以悬指针于where查看其参数：返回值为bool 的 函数
      _filteredSubCategories = _allSubCategories.where((subCategory) {
        return (subCategory.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
      notifyListeners();
    }
  }

  Future<List<Brand>> getAllBrands({bool showSnackBar = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'brands');
      if (response.isOk) {
        ApiResponse<List<Brand>> apiResponse =
            ApiResponse<List<Brand>>.fromJson(
          response.body,
          (json) => (json as List).map((item) => Brand.fromJson(item)).toList(),
        );
        _allBrands = apiResponse.data ?? [];
        _filteredBrands = List.from(_allBrands);
        notifyListeners();
        if (showSnackBar == true) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
        }
      }
    } catch (e) {
      print(e);
      if (showSnackBar == false) {
        SnackBarHelper.showSuccessSnackBar(e.toString());
      }
      rethrow;
    }
    return _filteredBrands;
  }

  void filterBrands(String keyword) {
    if (keyword.isEmpty) {
      _filteredBrands = List.from(_allBrands);
      notifyListeners();
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredBrands = _allBrands.where((brand) {
        return (brand.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
      notifyListeners();
    }
  }


  Future<List<Product>> getAllProducts({bool showSnackBar = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'products');
      if (response.isOk) {
        ApiResponse<List<Product>> apiResponse =
            ApiResponse<List<Product>>.fromJson(
          response.body,
          (json) =>
              (json as List).map((item) => Product.fromJson(item)).toList(),
        );
        _allProducts = apiResponse.data ?? [];
        _filteredProducts = List.from(_allProducts);
        notifyListeners();
        if (showSnackBar == true) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
        }
      }
    } catch (e) {
      print(e);
      if (!showSnackBar) {
        SnackBarHelper.showErrorSnackBar('An Error Occurred: $e');
      }
      rethrow;
    }
    return _filteredProducts;
  }

  void filterProducts(String keyword) {
    if (keyword.isEmpty) {
      _filteredProducts = List.from(_allProducts);
      notifyListeners();
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredProducts = _allProducts.where((product) {
        final productNameContainsKeyWord =
            (product.name ?? '').toLowerCase().contains(lowerKeyword);
        final categoryNameContainsKeyWord = (product.proCategoryId?.name
                ?.toLowerCase()
                .contains(lowerKeyword) ??
            false);
        final subCategoryNameContainsKeyWord = (product.proSubCategoryId?.name
                ?.toLowerCase()
                .contains(lowerKeyword)) ??
            false;
        return productNameContainsKeyWord ||
            categoryNameContainsKeyWord ||
            subCategoryNameContainsKeyWord;
      }).toList();
      notifyListeners();
    }
  }

  Future<List<Poster>> getAllPosters({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'posters');
      if (response.isOk) {
        ApiResponse<List<Poster>> apiResponse =
            ApiResponse<List<Poster>>.fromJson(
          response.body,
          (json) =>
              (json as List).map((item) => Poster.fromJson(item)).toList(),
        );
        _allPosters = apiResponse.data ?? [];
        _filteredPosters = List.from(_allPosters);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _filteredPosters;
  }

  void filterPosters(String keyword) {
    if (keyword.isEmpty) {
      _filteredPosters = List.from(_allPosters);
      notifyListeners();
    } else {
      final lowerKeyword = keyword.toLowerCase();
      //可以悬指针于where查看其参数：返回值为bool 的 函数
      _filteredPosters = _allPosters.where((poster) {
        return (poster.posterName ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
      notifyListeners();
    }
  }

  Future<List<Order>> getAllOrderByUser(
      {User? user, bool showSnack = false}) async {
    if (user == null) {
      return [];
    }
    try {
      Response response = await service.getItems(
          endpointUrl: 'orders/orderByUserId/${user.sId}');
      if (response.isOk) {
        ApiResponse<List<Order>> apiResponse =
            ApiResponse<List<Order>>.fromJson(
          response.body,
          (json) => (json as List).map((item) => Order.fromJson(item)).toList(),
        );
        _allOrders = apiResponse.data ?? [];
        _filteredOrders = List.from(_allOrders);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _allOrders;
  }

  double calculateDiscountPercentage(num originalPrice, num? discountedPrice) {
    if (originalPrice <= 0) {
      throw ArgumentError('Original price must be greater than zero.');
    }

    //? Ensure discountedPrice is not null; if it is, default to the original price (no discount)
    num finalDiscountedPrice = discountedPrice ?? originalPrice;

    if (finalDiscountedPrice > originalPrice) {
      return originalPrice.toDouble();
    }

    double discount =
        ((originalPrice - finalDiscountedPrice) / originalPrice) * 100;

    //? Return the discount percentage as an integer
    return discount;
  }
}
