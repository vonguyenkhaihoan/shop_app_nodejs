import 'package:shop_app/common/widgets/bottom_bar.dart';
import 'package:shop_app/features/address/screens/address_screen.dart';
import 'package:shop_app/features/admin/screen/add_category_screen.dart';
import 'package:shop_app/features/admin/screen/add_product_screen.dart';
import 'package:shop_app/features/admin/screen/admin_product_detail_screen.dart';
import 'package:shop_app/features/admin/screen/admin_update_screen.dart';
import 'package:shop_app/features/auth/screens/auth_screen.dart';
import 'package:shop_app/features/home/screen/catrgory_deals_screen.dart';
import 'package:shop_app/features/home/screen/home_screen.dart';
import 'package:shop_app/features/home/screen/top_rate_list_screen.dart';
import 'package:shop_app/features/order_details/screen/order_detail_screen.dart';
import 'package:shop_app/features/product_details/screens/product_detail_screen.dart';
import 'package:shop_app/features/profile/screen/update_profile_screem.dart';
import 'package:shop_app/features/search/screen/search_screen.dart';
import 'package:shop_app/models/order_model.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    //AUTH
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );

    //HOME
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );

    //BOTTOMBAR
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );

    //CategoryDealsScreen
    case CategoryDealsScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CategoryDealsScreen(
          category: category,
        ),
      );

    //Top Rate List Screen
    case TopRateList.routeName:
      var text = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => TopRateList(
          text: text,
        ),
      );

    //Search screen
    case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(
          searchQuery: searchQuery,
        ),
      );

    //Product Detail screen
    case ProductDetailScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductDetailScreen(
          product: product,
        ),
      );

    //ADDRESS PAGE
    case AddressScreen.routeName:
      var totalAmount = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddressScreen(
          totalAmount: totalAmount,
        ),
      );

    //Order detail PAGE
    case OrderDetailScreen.routeName:
      var order = routeSettings.arguments as Order;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDetailScreen(
          order: order,
        ),
      );

    //update  profile Screen
    case UpdateProfileScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const UpdateProfileScreen(),
      );

    /*-----------------------------------*/
    // ADMIN
    //ADD PRODUCT
    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddProductScreen(),
      );

    //ADD Category
    case AddCategoryScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddCategoryScreen(),
      );

    //update  profile Screen
    case AdminUpdateScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AdminUpdateScreen(),
      );

    //ADMIN Product Detail screen
    case AdminProductDetailScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AdminProductDetailScreen(
          product: product,
        ),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text("Screen does not exist!"),
          ),
        ),
      );
  }
}
