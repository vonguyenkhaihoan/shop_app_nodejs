// import 'package:shop_app/constains/global_variables.dart';
// import 'package:shop_app/features/admin/screen/admin_profile_screen.dart';
// import 'package:shop_app/features/admin/screen/analytics_screen.dart';
// import 'package:shop_app/features/admin/screen/order_screen.dart';
// import 'package:shop_app/features/admin/screen/post_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

// class AdminScreem extends StatefulWidget {
//   const AdminScreem({super.key});

//   @override
//   State<AdminScreem> createState() => _AdminScreemState();
// }

// class _AdminScreemState extends State<AdminScreem> {
//   //bien trang
//   int _page = 0;
//   double bottomBarWidget = 42;
//   double bottomBarBorderWidth = 5;

//   List<Widget> pages = [
//     const PostScren(),
//     const AnalyticsScreen(),
//     const OrderScreen(),
//     const AdminProfileScreen()
//   ];

//   void updatepage(int page) {
//     setState(() {
//       _page = page;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //AppBar
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(50),
//         child: AppBar(
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(
//               gradient: GlobalVariables.appBarGradient,
//             ),
//           ),
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 alignment: Alignment.topLeft,
//                 child: Image.asset(
//                   'assets/images/amazon_in.png',
//                   width: 120,
//                   height: 45,
//                   color: Colors.black,
//                 ),
//               ),
//               Container(
//                 child: Text(
//                   'Admin',
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold, color: Colors.black),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),

//       //Navgation
//       body: pages[_page],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _page,
//         selectedItemColor: GlobalVariables.selectedNavBarColor,
//         unselectedItemColor: GlobalVariables.unselectedNavBarColor,
//         backgroundColor: GlobalVariables.backgroundColor,
//         iconSize: 28,
//         onTap: updatepage,
//         items: [
//           //Post Page
//           BottomNavigationBarItem(
//             icon: Container(
//               width: bottomBarWidget,
//               decoration: BoxDecoration(
//                 border: Border(
//                   top: BorderSide(
//                     color: _page == 0
//                         ? GlobalVariables.selectedNavBarColor
//                         : GlobalVariables.backgroundColor,
//                     width: bottomBarBorderWidth,
//                   ),
//                 ),
//               ),
//               child: const Icon(
//                 Icons.home_outlined,
//               ),
//             ),
//             label: '',
//           ),

//           //ANALUTICS PAGE
//           BottomNavigationBarItem(
//             icon: Container(
//               width: bottomBarWidget,
//               decoration: BoxDecoration(
//                 border: Border(
//                   top: BorderSide(
//                     color: _page == 1
//                         ? GlobalVariables.selectedNavBarColor
//                         : GlobalVariables.backgroundColor,
//                     width: bottomBarBorderWidth,
//                   ),
//                 ),
//               ),
//               child: const Icon(Icons.analytics_outlined),
//             ),
//             label: '',
//           ),

//           //CART PAGE
//           BottomNavigationBarItem(
//             icon: Container(
//               width: bottomBarWidget,
//               decoration: BoxDecoration(
//                 border: Border(
//                   top: BorderSide(
//                     color: _page == 2
//                         ? GlobalVariables.selectedNavBarColor
//                         : GlobalVariables.backgroundColor,
//                     width: bottomBarBorderWidth,
//                   ),
//                 ),
//               ),
//               child: const Icon(
//                 Icons.all_inbox_outlined,
//               ),
//             ),
//             label: '',
//           ),

//           //CART PAGE
//           BottomNavigationBarItem(
//             icon: Container(
//               width: bottomBarWidget,
//               decoration: BoxDecoration(
//                 border: Border(
//                   top: BorderSide(
//                     color: _page == 3
//                         ? GlobalVariables.selectedNavBarColor
//                         : GlobalVariables.backgroundColor,
//                     width: bottomBarBorderWidth,
//                   ),
//                 ),
//               ),
//               child: const Icon(
//                 Icons.person_outline_outlined,
//               ),
//             ),
//             label: '',
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:shop_app/constains/global_variables.dart';
// import 'package:shop_app/features/admin/screen/admin_profile_screen.dart';
// import 'package:shop_app/features/admin/screen/analytics_screen.dart';
// import 'package:shop_app/features/admin/screen/order_screen.dart';
// import 'package:shop_app/features/admin/screen/post_screen.dart';

// class AdminScreem extends StatefulWidget {
//   const AdminScreem({Key? key}) : super(key: key);

//   @override
//   State<AdminScreem> createState() => _AdminScreemState();
// }

// class _AdminScreemState extends State<AdminScreem> {
//   int _page = 0;
//   double bottomBarWidget = 42;
//   double bottomBarBorderWidth = 5;

//   List<Widget> pages = [
//     const PostScren(),
//     const AnalyticsScreen(),
//     const OrderScreen(),
//     const AdminProfileScreen()
//   ];

//   void updatepage(int page) {
//     setState(() {
//       _page = page;
//     });
//   }

//   Widget buildDrawer() {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           UserAccountsDrawerHeader(
//             accountName: Text("Your Name"),
//             accountEmail: Text("your@email.com"),
//             currentAccountPicture: Container(
//               height: 100,
//               width: 100,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 image: DecorationImage(
//                   image: NetworkImage('https://picsum.photos/200'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             decoration: BoxDecoration(
//               gradient: GlobalVariables.appBarGradient,
//             ),
//           ),

//           ListTile(
//             leading: Icon(Icons.production_quantity_limits_sharp),
//             title: Text('Quản lý sản phẩm'),
//             onTap: () {
//               // Add the functionality you want for this item
//               updatepage(0);
//               Navigator.pop(context); // Close the drawer
//             },
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.analytics),
//             title: Text('Thống kê'),
//             onTap: () {
//               // Add the functionality you want for this item
//               updatepage(1);
//               Navigator.pop(context); // Close the drawer
//             },
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.all_inbox),
//             title: Text('Quản lý đơn hàng'),
//             onTap: () {
//               // Add the functionality you want for this item
//               updatepage(2);
//               Navigator.pop(context); // Close the drawer
//             },
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.person),
//             title: Text('Thông tin cá nhân'),
//             onTap: () {
//               // Add the functionality you want for this item
//               updatepage(3);
//               Navigator.pop(context); // Close the drawer
//             },
//           ),
//           Divider(), // Thêm đường phân cách
//           ListTile(
//             leading: Icon(Icons.exit_to_app),
//             title: Text('Đăng xuất'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(50),
//         child: AppBar(
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(
//               gradient: GlobalVariables.appBarGradient,
//             ),
//           ),
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 alignment: Alignment.topLeft,
//                 child: Image.asset(
//                   'assets/images/amazon_in.png',
//                   width: 120,
//                   height: 45,
//                   color: Colors.black,
//                 ),
//               ),
//               Container(
//                 child: Text(
//                   'Admin',
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold, color: Colors.black),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       drawer: buildDrawer(),
//       body: pages[_page],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shop_app/constains/global_variables.dart';
import 'package:shop_app/features/admin/screen/admin_profile_screen.dart';
import 'package:shop_app/features/admin/screen/analytics_screen.dart';
import 'package:shop_app/features/admin/screen/category_manager_screen.dart';
import 'package:shop_app/features/admin/screen/order_screen.dart';
import 'package:shop_app/features/admin/screen/post_screen.dart';
import 'package:shop_app/features/home/screen/catrgory_deals_screen.dart';
import 'package:shop_app/features/profile/services/profile_services.dart';

class AdminScreem extends StatefulWidget {
  const AdminScreem({Key? key}) : super(key: key);

  @override
  State<AdminScreem> createState() => _AdminScreemState();
}

class _AdminScreemState extends State<AdminScreem> {
  int _page = 0;
  double bottomBarWidget = 42;
  double bottomBarBorderWidth = 5;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  List<Widget> pages = [
    const PostScren(),
    const CategoryManagementScreen(),
    const AnalyticsScreen(),
    const OrderScreen(),
    const AdminProfileScreen()
  ];

  void updatepage(int page) {
    setState(() {
      _page = page;
    });

    if (_listKey.currentState != null) {
      _listKey.currentState!.insertItem(page);
    }

    Navigator.pop(context);
  }

  Widget buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Your Name"),
            accountEmail: Text("your@email.com"),
            currentAccountPicture: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage('https://picsum.photos/200'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          buildListTile(
              0, Icons.production_quantity_limits_sharp, 'Quản lý sản phẩm'),
          buildListTile(1, Icons.category, 'Quản lý danh mục'),
          buildListTile(2, Icons.analytics, 'Thống kê'),
          buildListTile(3, Icons.all_inbox, 'Quản lý đơn hàng'),
          buildListTile(4, Icons.person, 'Thông tin cá nhân'),
          Divider(),
          buildListTile(5, Icons.exit_to_app, 'Đăng xuất',
              onTap: () => ProfileServices().logOut(context)),
        ],
      ),
    );
  }

  Widget buildListTile(int index, IconData icon, String title,
      {VoidCallback? onTap}) {
    bool isSelected = _page == index;

    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap();
        } else {
          updatepage(index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: isSelected ? Colors.grey[200] : Colors.transparent,
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          selected: isSelected,
          selectedTileColor: Colors.grey[200],
        ),
      ),
    );
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/images/amazon_in.png',
                  width: 120,
                  height: 45,
                  color: Colors.black,
                ),
              ),
              Container(
                child: Text(
                  'Admin',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: buildDrawer(),
      body: pages[_page],
    );
  }
}

