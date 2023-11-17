import 'package:shop_app/common/widgets/custom_button.dart';
import 'package:shop_app/common/widgets/custom_textfield.dart';
import 'package:shop_app/config/payment_configurations.dart';
import 'package:shop_app/constains/global_variables.dart';
import 'package:shop_app/constains/utils.dart';
import 'package:shop_app/features/address/services/address_services.dart';
import 'package:shop_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
// import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  const AddressScreen({super.key, required this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController streetController = TextEditingController();
  final TextEditingController communeController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final _addressFormKey = GlobalKey<FormState>();

  //địa chỉ được sửa dụng
  String addressToBeUsed = "";
  String phoneToBeUsed = "";

  //san pham thanh toan
  // List<PaymentItem> paymentItems = [];
  //address services
  final AddressServices addressServices = AddressServices();

  @override
  void initState() {
    super.initState();
    // paymentItems.add(
    //   PaymentItem(
    //     amount: widget.totalAmount,
    //     label: 'Total Amount',
    //     status: PaymentItemStatus.final_price,
    //   ),
    // );
  }

  @override
  void dispose() {
    super.dispose();
    streetController.dispose();
    communeController.dispose();
    districtController.dispose();
    cityController.dispose();
  }

  //ket qua apple
  void onApplePayResult(res) {}
  //ket qua apple
  void onGooglePayResult(res) {}

  //
  void payPressed(String addressFromProvider, String phoneFromProvider) {
    addressToBeUsed = "";
    phoneToBeUsed = "";

    // kiem tra bieu mau co trong nếu một trông các cái là sai nghĩa là trống hết
    bool isForm = streetController.text.isNotEmpty ||
        communeController.text.isNotEmpty ||
        districtController.text.isNotEmpty ||
        cityController.text.isNotEmpty ||
        phoneController.text.isNotEmpty;

    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            '${streetController.text}, ${communeController.text},  ${districtController.text},${cityController.text}';
        phoneToBeUsed = '${phoneController.text}';
        // kiểm tra độ dài số điện thoại
        if (phoneController.text.length == 10) {
          print('Phone number is 10 digits long');
        } else {
          showSnackBar(
              context, 'Phone number must be 10 digits long', Colors.red[300]!);
          return;
        }
      } else {
        throw Exception('Please enter all the values!');
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
      phoneToBeUsed = phoneFromProvider;
    } else {
      showSnackBar(context, 'Form Address Emty', Colors.red[300]!);
    }
    print(addressToBeUsed);
    // addressServices.saveUserAddress(context: context, address: addressToBeUsed);
    addressServices.placeOrder(
        context: context,
        address: addressToBeUsed,
        phone: phoneToBeUsed,
        totalSum: double.parse(widget.totalAmount));
  }

  @override
  Widget build(BuildContext context) {
    //lay dia chi da có san
    var user = context.watch<UserProvider>().user;

    //
    return Scaffold(
      //app bar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Text(
            'Check out',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),

      // body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (user.address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              user.address,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              user.phone,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),

              //nhap dia chi mun nhan hang
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: streetController,
                      hintText: 'No. Street',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: communeController,
                      hintText: 'Commune/Ward',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: districtController,
                      hintText: 'district',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: cityController,
                      hintText: 'Town/City',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: phoneController,
                      hintText: 'Phone ',
                    ),
                  ],
                ),
              ),

              /*//applepay
              ApplePayButton(
                width: double.infinity,
                style: ApplePayButtonStyle.whiteOutline,
                type: ApplePayButtonType.buy,
                paymentConfiguration:
                    PaymentConfiguration.fromJsonString(defaultApplePay),
                onPaymentResult: onApplePayResult,
                paymentItems: paymentItems,
                margin: const EdgeInsets.only(top: 15),
                height: 50,
              ),

              const SizedBox(height: 10),

              GooglePayButton(
                paymentConfiguration:
                    PaymentConfiguration.fromJsonString(defaultGooglePay),
                onPaymentResult: onGooglePayResult,
                paymentItems: paymentItems,
                height: 50,
                // style: GooglePayButtonStyle.black,
                type: GooglePayButtonType.buy,
                margin: const EdgeInsets.only(top: 15),
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),*/

              //button check out
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  text: 'Buy',
                  onTap: () => payPressed(user.address, user.phone),
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
