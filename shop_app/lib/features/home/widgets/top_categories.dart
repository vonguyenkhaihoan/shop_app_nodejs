import 'package:shop_app/constains/global_variables.dart';
import 'package:shop_app/features/home/screen/catrgory_deals_screen.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/features/home/services/home_services.dart';
import 'package:shop_app/models/category_model.dart';

class TopCategories extends StatefulWidget {
  const TopCategories({super.key});

  @override
  State<TopCategories> createState() => _TopCategoriesState();
}

class _TopCategoriesState extends State<TopCategories> {
  final HomeServices homeServices = HomeServices();
  List<Category>? categoryList;

  void navigateToCategoryPage(BuildContext context, String category) {
    Navigator.pushNamed(context, CategoryDealsScreen.routeName,
        arguments: category);
  }

  @override
  void initState() {
    super.initState();
    allCategory();
  }

  // ham lay ds san pham
  allCategory() async {
    categoryList = await homeServices.getAllCategories(context);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        itemCount: categoryList?.length ?? 0,
        scrollDirection: Axis.horizontal,
        itemExtent: 75,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => navigateToCategoryPage(
              context,
              categoryList![index].name,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      GlobalVariables.categoryImages[index]['image']!,
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
                Text(
                  categoryList![index].name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
