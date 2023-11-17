import 'package:shop_app/common/widgets/custom_button.dart';
import 'package:shop_app/common/widgets/custom_textfield.dart';
import 'package:shop_app/constains/global_variables.dart';
import 'package:shop_app/features/admin/services/admin_services.dart';
import 'package:flutter/material.dart';

class AdminUpdateScreen extends StatefulWidget {
  static const String routeName = '/admin-update-Profile';
  const AdminUpdateScreen({super.key});

  @override
  State<AdminUpdateScreen> createState() => _AdminUpdateScreenState();
}

class _AdminUpdateScreenState extends State<AdminUpdateScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String gender = 'Orther';
  final _updateFormKey = GlobalKey<FormState>();
  AdminServices adminServices = AdminServices();

  List<String> genderList = [
    'Orther',
    'Male',
    'Shemale',
  ];

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    addressController.dispose();
    phoneController.dispose();
  }

  void updateProfile() {
    if (_updateFormKey.currentState!.validate()) {
      adminServices.updateAdminProfile(
          context: context,
          address: addressController.text,
          name: usernameController.text,
          phone: phoneController.text,
          gender: gender);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Text(
            'Update information',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                key: _updateFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: usernameController,
                      hintText: 'User Name',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: addressController,
                      hintText: 'Address',
                      maxLines: 7,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: phoneController,
                      hintText: 'Phone munber',
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: DropdownButton(
                        value: gender,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: genderList.map((String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newVal) {
                          setState(() {
                            gender = newVal!;
                          });
                        },
                      ),
                    ),

                    //
                  ],
                ),
              ),
              CustomButton(
                text: 'Save',
                onTap: updateProfile,
                color: Colors.yellow[600],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
