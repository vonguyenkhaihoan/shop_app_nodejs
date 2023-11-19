import 'package:shop_app/common/widgets/big_text.dart';
import 'package:shop_app/common/widgets/custom_button.dart';
import 'package:shop_app/constains/global_variables.dart';
import 'package:shop_app/features/profile/screen/update_profile_screem.dart';
import 'package:shop_app/features/profile/services/profile_services.dart';
import 'package:shop_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    void navigateToUpodateProfileScreen() {
      Navigator.pushNamed(
        context,
        UpdateProfileScreen.routeName,
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Center(
            child: Text(
              'User information',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),

      //body
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Tiêu đề
              // Text(
              //   'Thông tin cá nhân',
              //   style: TextStyle(
              //     fontSize: 20,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),

              // Ảnh đại diện
              SizedBox(height: 10),
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage('https://picsum.photos/200'),
                  ),
                ),
              ),

              // User Name
              SizedBox(height: 10),
              Text(
                " ${user.name}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Thông tin cá nhân
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
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
                    Text(
                      'Email:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BigText(text: user.email),
                    const SizedBox(height: 10),
                    Text(
                      'Address:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BigText(text: user.address),
                    const SizedBox(height: 10),
                    Text(
                      'Phone Number:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BigText(text: user.phone),
                    const SizedBox(height: 10),
                    Text(
                      'Gender:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BigText(text: user.gender),
                  ],
                ),
              ),

              //update Profile
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  text: 'Update',
                  onTap: () {
                    navigateToUpodateProfileScreen();
                  },
                  color: Colors.yellow[600],
                ),
              ),

              //log out
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  text: 'Log out',
                  onTap: () => ProfileServices().logOut(context),
                  color: Colors.yellow[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
