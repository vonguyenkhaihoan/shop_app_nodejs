import 'package:shop_app/common/widgets/custom_button.dart';
import 'package:shop_app/common/widgets/custom_textfield.dart';
import 'package:shop_app/constains/global_variables.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AdminProductDetailScreen extends StatefulWidget {
  static const String routeName = '/admin-product-details';
  final Product product;
  const AdminProductDetailScreen({super.key, required this.product});

  @override
  State<AdminProductDetailScreen> createState() =>
      _AdminProductDetailScreenState();
}

class _AdminProductDetailScreenState extends State<AdminProductDetailScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final _updateProductFormKey = GlobalKey<FormState>();
  String category = 'Mobiles';

  // String category = '';
  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

  List<String> productCategories = [
    'Mobiles',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion'
  ];

  @override
  Widget build(BuildContext context) {
    final products = widget.product;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const Text(
            'Add Product',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),

      //body
      body: SingleChildScrollView(
        child: Form(
          key: _updateProductFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                CustomTextField(
                  controller: productNameController,
                  hintText: products.name,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: descriptionController,
                  hintText: products.description,
                  maxLines: 7,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: priceController,
                  hintText: products.price.toString(),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: quantityController,
                  hintText: products.quantity.toString(),
                ),
                const SizedBox(height: 10),
                // Lấy danh mục hiện tại từ sản phẩm.

                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    value: category, // Đặt giá trị ban đầu của nút thả xuống thành danh mục hiện tại.
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: productCategories.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        category =
                            newVal!; // Cập nhật danh mục hiện tại khi người dùng chọn một mục mới từ nút thả xuống.
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Sell',
                  onTap: () {} /*sellProduct*/,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
