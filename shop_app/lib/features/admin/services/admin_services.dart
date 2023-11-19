import 'dart:convert';
import 'dart:io';

import 'package:shop_app/config/config.dart';
import 'package:shop_app/constains/error_handling.dart';
import 'package:shop_app/constains/utils.dart';
import 'package:shop_app/features/admin/models/sales.dart';
import 'package:shop_app/features/admin/widgets/bartChart_CatPercen.dart';
import 'package:shop_app/models/category_model.dart';
import 'package:shop_app/models/order_model.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/models/user_model.dart';
import 'package:shop_app/provider/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AdminServices {
  //lay danh mục
  Future<List<Category>> getAllCategories(BuildContext context) async {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Category> categoryList = [];

    try {
      http.Response res = await http.get(Uri.parse(apiAllCaterogy), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        // 'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          //chay vong lap san pham lays tudb
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            //them vao danh sach san pham
            categoryList.add(
              Category.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red);
    }
    return categoryList;
  }

  // Hàm để thêm danh mục
  Future<void> addCategory({
    required String categoryName,
    required String categoryDescription,
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse(apiaddCategory),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'name': categoryName,
          'description': categoryDescription,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          Navigator.pop(context);
          showSnackBar(context, 'Product Added Successfully!', Colors.green);
        },
      );
    } catch (e) {
      print('Error adding category: $e');
      showSnackBar(
          context, e.toString(), const Color.fromARGB(255, 161, 117, 113));
    }
  }

  // Hàm để xóa danh mục
  Future<void> deleteCategory({
    required String categoryId,
    required BuildContext context,
  }) async {
    try {
      http.Response res = await http.delete(
        Uri.parse(apideleteCategory + '/$categoryId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Delete Category Successfully', Colors.green);
        },
      );
    } catch (e) {
      print('Error deleting category: $e');
      showSnackBar(
          context, e.toString(), const Color.fromARGB(255, 161, 117, 113));
    }
  }

  //ham cap nhat danh muc
  Future<void> updateCategory({
    required String categoryId,
    required String categoryName,
    required String categoryDescription,
    required BuildContext context,
  }) async {
    try {
      final response = await http.put(
        Uri.parse(apiUpdateCategory + '/$categoryId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': categoryName,
          'description': categoryDescription,
        }),
      );

      if (response.statusCode == 200) {
        // Cập nhật thành công, bạn có thể xử lý dữ liệu trả về ở đây nếu cần
        print('Category updated successfully');
      } else if (response.statusCode == 404) {
        // Danh mục không tồn tại
        print('Category not found');
      } else {
        // Xử lý lỗi khác nếu cần
        print('Error updating category: ${response.statusCode}');
      }
    } catch (error) {
      // Xử lý lỗi kết nối hoặc lỗi khác
      print('Error updating category: $error');
    }
  }

  //sell product
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final cloudinary = CloudinaryPublic('dgcuvbmzi', 'xhvxotwr');
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: "product/" + name),
        );
        imageUrls.add(res.secureUrl);
      }

      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        images: imageUrls,
        category: category,
        price: price,
      );

      http.Response res = await http.post(
        Uri.parse(addProduct),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          Navigator.pop(context);
          showSnackBar1(context, 'Product Added Successfully!');
        },
      );
    } catch (e) {
      showSnackBar(
          context, e.toString(), const Color.fromARGB(255, 161, 117, 113));
    }
  }

  //get all product
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    //tao bien luu danh sach san pham
    List<Product> productList = [];

    try {
      http.Response res = await http.get(Uri.parse(getAllProduct), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          //chay vong lap san pham lays tudb
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            //them vao danh sach san pham
            productList.add(
              Product.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red);
    }
    return productList;
  }

  //delete Product
  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse(deleteProducts),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(
          context, e.toString(), const Color.fromARGB(255, 161, 117, 113));
    }
  }

  //get all order
  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    //tao bien luu danh sach san pham
    List<Order> orderList = [];

    try {
      http.Response res = await http.get(Uri.parse(getAllOrder), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          //chay vong lap san pham lays tudb
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            //them vao danh sach san pham
            orderList.add(
              Order.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red);
    }
    return orderList;
  }

  //change status order
  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse(changeStatusOrder),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'id': order.id, 'status': status}),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(
          context, e.toString(), const Color.fromARGB(255, 161, 117, 113));
    }
  }

  //hàm lấy danh thu theo danh mục
  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Sales> sales = [];
    int totalEarning = 0;
    try {
      http.Response res = await http.get(Uri.parse(getAnalytics), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var response = jsonDecode(res.body);
          totalEarning = response['totalEarnings'];
          sales = [
            Sales('Mobiles', response['mobileEarnings']),
            Sales('Essentials', response['essentialEarnings']),
            Sales('Books', response['booksEarnings']),
            Sales('Appliances', response['applianceEarnings']),
            Sales('Fashion', response['fashionEarnings']),
          ];
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red[300]!);
    }
    return {
      'sales': sales,
      'totalEarnings': totalEarning,
    };
  }

  // lay tong so don hang
  Future<int> getTotalOrder(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    int totalOrder = 0;

    try {
      http.Response res = await http.get(Uri.parse(totalOrders), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var response = jsonDecode(res.body);
          totalOrder = response['totalOrders'];
        },
      );

      // return Future.value(totalOrder);
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red[300]!);
    }
    return Future.value(totalOrder);
  }

  //tổng số tiền bán dược
  Future<int> getTotalMoneyOrder(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    int totalRevenue = 0;

    try {
      http.Response res = await http.get(Uri.parse(totalMoneyOrder), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var response = jsonDecode(res.body);
          totalRevenue = response['totalRevenue'];
        },
      );

      // return Future.value(totalOrder);
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red[300]!);
    }
    return Future.value(totalRevenue);
  }

  //lay tong so long san pham
  Future<int> getTotalProduct(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    int totalProduct = 0;

    try {
      http.Response res = await http.get(Uri.parse(totalProducts), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var response = jsonDecode(res.body);
          totalProduct = response['totalProduct'];
        },
      );

      // return Future.value(totalOrder);
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red[300]!);
    }
    return Future.value(totalProduct);
  }

  //llay phân trăm danh mục có so luong san pham trong tong san lương
  static Future<List<CategoryData>> fetchData() async {
    final response = await http.get(Uri.parse(apiCatePercent));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => CategoryData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  //Update admin profile
  void updateAdminProfile({
    required BuildContext context,
    required String address,
    required String name,
    required String phone,
    required String gender,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse(adminUpdate),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'address': address,
          'name': name,
          'phone': phone,
          'gender': gender
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user = userProvider.user.copyWith(
            address: jsonDecode(res.body)['address'],
            name: jsonDecode(res.body)['name'],
            phone: jsonDecode(res.body)['phone'],
            gender: jsonDecode(res.body)['gender'],
          );
          userProvider.setUserFromModel(user);
          Navigator.pop(context);
          showSnackBar(context, 'Update successfully', Colors.green);
        },
      );
    } catch (e) {
      showSnackBar(
          context, e.toString(), const Color.fromARGB(255, 161, 117, 113));
    }
  }
}
