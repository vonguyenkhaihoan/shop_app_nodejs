import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shop_app/common/widgets/loader.dart';
import 'package:shop_app/constains/global_variables.dart';
import 'package:shop_app/constains/utils.dart';
import 'package:shop_app/features/admin/screen/add_category_screen.dart';
import 'package:shop_app/features/admin/services/admin_services.dart';
import 'package:shop_app/models/category_model.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  final AdminServices adminServices = AdminServices();
  List<Category>? categories;
  int totalCategories = 0;

  @override
  void initState() {
    super.initState();
    allCategory();
  }

  // ham lay ds danh mục
  allCategory() async {
    categories = await adminServices.getAllCategories(context);
    totalCategories =
        categories?.length ?? 0; // Set the total number of categories
    setState(() {});
  }

  //ham xoa danh muc
  void deleteCategory(String categoryId) async {
    // Kiểm tra số lượng danh mục trước khi xóa
    if (categories != null && categories!.length > 1) {
      await adminServices.deleteCategory(
        categoryId: categoryId,
        context: context,
      );
      // Sau khi xóa, cập nhật danh sách danh mục hoặc thực hiện các hành động cần thiết
      await refresh();
    } else {
      showSnackBar(context, "Phải có ít nhất một danh mục.",
          const Color.fromARGB(255, 161, 117, 113));
    }
  }

  void navigateToAddCategory({String? categoryId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCategoryScreen(
          categoryId: categoryId,
        ),
      ),
    ).then((result) {
      // Xử lý kết quả nếu cần

      if (result != null && result is bool && result) {
        // Làm mới danh sách danh mục khi quay lại từ AddCategoryScreen
        refresh();
      }
    });
  }

  // lam moi giao dien
  Future<void> refresh() async {
    allCategory();
    // Refresh product data here
    setState(() {});
    return Future.delayed(const Duration(seconds: 4));
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      onRefresh: refresh,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Scaffold(
          // appBar: AppBar(
          //   title: const Text('Quản Lý Danh Mục'),
          // ),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: GlobalVariables.appBarGradient,
                ),
              ),
              title: const Center(
                child: Text(
                  "Quản Lý Danh Mục",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),

          //body
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black,
                  width: 0.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Tổng số danh mục: $totalCategories'),
                  ),
                  Expanded(
                    child: categories == null
                        ? const Loader()
                        : ListView.builder(
                            itemCount: categories!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                        '${index + 1}. ${categories![index].name}'),
                                    onTap: () {
                                      // Chuyển hướng đến AddCategoryScreen để sửa đổi
                                      navigateToAddCategory(
                                        categoryId: categories![index].id,
                                      );
                                    },
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            // Chuyển hướng đến AddCategoryScreen để sửa đổi
                                            navigateToAddCategory(
                                              categoryId: categories![index].id,
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            deleteCategory(
                                                categories![index].id);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 2.0,
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          //nut hanh dong noi
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              navigateToAddCategory();
            },
            tooltip: 'Add a Category',
            child: const Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }
}
