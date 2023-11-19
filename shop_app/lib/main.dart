import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shop_app/common/widgets/bottom_bar.dart';
import 'package:shop_app/constains/global_variables.dart';
import 'package:shop_app/features/admin/screen/admin_screen.dart';
import 'package:shop_app/features/auth/screens/auth_screen.dart';
import 'package:shop_app/features/auth/service/auth_service.dart';
import 'package:shop_app/provider/user_provider.dart';
import 'package:shop_app/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  //Initialize Flutter Binding
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey =
      "pk_test_51OAz42JmIpBKLti4fXgYDz7nEKk7fieR3XZcM7eWTxM9NZRPWJ8DZjgBqTBLiO57rnnjI4ehmkLsJTitEpuSoFk500DxQfMkCi";

  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authservice = AuthService();

  @override
  void initState() {
    super.initState();
    authservice.getUserData(context);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Shop App',
        debugShowCheckedModeBanner: false,
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
          // useMaterial3: true,
        ),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: Provider.of<UserProvider>(context).user.token.isNotEmpty
            ? Provider.of<UserProvider>(context).user.type == 'user'
                ? const BottomBar()
                : const AdminScreem()
            : const AuthScreen());
  }
}
