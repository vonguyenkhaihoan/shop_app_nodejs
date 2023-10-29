import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constanst/global_variables.dart';
import 'package:shop_app/features/auth/screen/auth_screen.dart';
import 'package:shop_app/provider/user_provider.dart';

import 'package:shop_app/route.dart';

void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'F',
        theme: ThemeData(
          scaffoldBackgroundColor: GlobalVariables.backgroundColor,
          colorScheme: const ColorScheme.light(
            primary: GlobalVariables.secondaryColor,
          ),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
        ),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: const AuthScreen());
  }
}
