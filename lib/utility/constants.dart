import 'dart:ui';

import 'package:e_commerce_flutter/models/category.dart';
import 'package:e_commerce_flutter/models/product.dart';

const MAIN_URL = 'http://10.0.2.2:3000';
const FAVORITE_PRODUCT_BOX = 'FAVORITE_PRODUCT_BOX';
const USER_INFO_BOX = 'USER_INFO_BOX';

const PHONE_KEY = 'PHONE_KEY';
const STREET_KEY = 'STREET_KEY';
const CITY_KEY = 'CITY_KEY';
const STATE_KEY = 'STATE_KEY';
const POSTAL_CODE_KEY = 'POSTAL_CODE_KEY';
const COUNTRY_KEY = 'COUNTRY_KEY';
const IPV4 = '172.19.199.87';

String getImageUrl(String? url) {
  if (url == '' || url == null) {
    return '';
  }
  String s = url.replaceAll('localhost', IPV4);
  return s;
}

List<Images> getImagesUrl(List<Images> images) {
  List<Images> returnImages = [];
  for (var image in images) {
    if (image.url == '' || image.url == null) {
      continue;
    }
    Images i = Images(sId: image.sId, url: image.url, image: image.image);
    String s = i.url!.replaceAll('localhost', IPV4);
    i.url = s;
    returnImages.add(i);
  }
  return returnImages;
}
