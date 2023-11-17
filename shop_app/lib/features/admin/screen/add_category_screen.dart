import 'package:flutter/material.dart';
import 'package:shop_app/constains/global_variables.dart';
import 'package:shop_app/features/admin/services/admin_services.dart';

class AddCategoryScreen extends StatefulWidget {
  static const String routeName = '/add-category-screen';
  final String? categoryId; // Tham số mới để nhận ID danh mục cho việc sửa đổi
  const AddCategoryScreen({super.key, this.categoryId});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _categoryNameController = TextEditingController();
  TextEditingController _categoryDescriptionController =
      TextEditingController();
  final AdminServices adminServices = AdminServices();

  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    // Kiểm tra xem có ID danh mục được chuyển qua không, cho biết là đang ở chế độ sửa đổi hay thêm mới
    isEditMode = widget.categoryId != null && widget.categoryId!.isNotEmpty;

    if (isEditMode) {
      // Tải chi tiết danh mục để sửa đổi
      loadCategoryDetails();
    }
  }

  // Tải chi tiết danh mục để sửa đổi
  void loadCategoryDetails() async {}

  //ham cap nhat hoac them
  void addOrUpdateCategory() {
    if (_formKey.currentState!.validate()) {
      if (isEditMode) {
        try {
          adminServices.updateCategory(
            categoryId: widget.categoryId!,
            categoryName: _categoryNameController.text,
            categoryDescription: _categoryDescriptionController.text,
            context: context,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Category updated successfully'),
            ),
          );
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating category: $error'),
            ),
          );
        }
      } else {
        // Xử lý thêm danh mục mới
        adminServices.addCategory(
          categoryName: _categoryNameController.text,
          categoryDescription: _categoryDescriptionController.text,
          context: context,
        );
      }

    }
  }

  @override
  Widget build(BuildContext context) {
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
            'Add Category',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),

      //
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Category Name:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _categoryNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter category name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter category name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Category Description:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _categoryDescriptionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter category description';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter category description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Hiển thị nút "Cập nhật danh mục" chỉ trong chế độ sửa đổi
                  isEditMode
                      ? ElevatedButton(
                          onPressed: () {
                            addOrUpdateCategory();
                          },
                          child: Text('Update'),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            addOrUpdateCategory();
                          },
                          child: Text('Add Category'),
                        ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_categoryNameController.text.isNotEmpty ||
                          _categoryDescriptionController.text.isNotEmpty) {
                        _formKey.currentState?.reset();
                      }
                    },
                    child: Text('Reset'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context,
                          false); // Đóng màn hình và truyền giá trị false làm kết quả
                    },
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
