import 'package:e_commerce_flutter/models/api_response.dart';
import 'package:e_commerce_flutter/utility/snack_bar_helper.dart';
import 'package:flutter_login/flutter_login.dart';

import '../../../core/data/data_provider.dart';
import '../../../../models/user.dart';
import '../login_screen.dart';
import '../../../../services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../utility/constants.dart';

class UserProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final box = GetStorage();

  UserProvider(this._dataProvider);

  Future<String?> login(LoginData data) async {
    try {
      Map<String, dynamic> loginData = {
        'name': data.name.toString(),
        'password': data.password
      };
      final Response response = await service.addItem(
          endpointUrl: 'users/login', itemData: loginData);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body,
            (json) => User.fromJson(json as Map<String, dynamic>)); //这里
        if (apiResponse.success == true) {
          print("yaaaaaaaaaa");
          User user = apiResponse.data;
          saveLoginInfo(user); //和这里都和register不一样
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          //log()
          return null;
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Filed to Login: ${apiResponse.message}');
          return 'Filed to Login: ${apiResponse.message}';
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}');
        return 'Error ${response.body?['message'] ?? response.statusText}';
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An Error occurred: $e');
    }
    return null;
  }

  Future<String?> register(SignupData data) async {
    try {
      Map<String, dynamic> user = {
        'name': data.name?.toString(),
        'password': data.password
      };
      final Response response =
          await service.addItem(endpointUrl: "users/register", itemData: user);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          //log()
          return null;
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Filed to Register: ${apiResponse.message}');
          return 'Filed to Register: ${apiResponse.message}';
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}');

        print('Error ${response.body?['message'] ?? response.statusText}');
        return 'Error ${response.body?['message'] ?? response.statusText}';
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An Error occurred: $e');
    }
    return null;
  }

  Future<void> saveLoginInfo(User? loginUser) async {
    await box.write(USER_INFO_BOX, loginUser?.toJson());
    Map<String, dynamic>? userJson = box.read(USER_INFO_BOX);
  }

  User? getLoginUsr() {
    Map<String, dynamic>? userJson = box.read(USER_INFO_BOX);
    User? userLogged = User.fromJson(userJson ?? {});
    return userLogged;
  }

  logOutUser() {
    box.remove(USER_INFO_BOX);
    Get.offAll(const LoginScreen());
  }
}
