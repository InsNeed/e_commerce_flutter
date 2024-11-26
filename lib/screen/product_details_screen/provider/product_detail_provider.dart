import 'package:e_commerce_flutter/models/product.dart';
import 'package:e_commerce_flutter/utility/snack_bar_helper.dart';
import 'package:e_commerce_flutter/utility/utility_extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import '../../../core/data/data_provider.dart';

class ProductDetailProvider extends ChangeNotifier {
  final DataProvider _dataProvider;
  String? selectedVariant;
  var flutterCart = FlutterCart();

  ProductDetailProvider(this._dataProvider);

  void addToCart(Product product) {
    if (product.proVariantId!.isNotEmpty && selectedVariant == null) {
      SnackBarHelper.showErrorSnackBar('Plz select a variant');
      return;
    }
    double? price = product.offerPrice != product.price
        ? product.offerPrice
        : product.price;
    flutterCart.addToCart(
        cartModel: CartModel(
            productId: '${product.sId}',
            productName: '${product.name}',
            variants: [
              ProductVariant(price: price ?? 0, color: selectedVariant)
            ],
            productImages: ['${product.images?.safeElementAt(0)?.url}'],
            productDetails: '${product.description}'));
    selectedVariant = null;
    SnackBarHelper.showSuccessSnackBar('item added');
    notifyListeners();
  }

  void updateUI() {
    notifyListeners();
  }
}
