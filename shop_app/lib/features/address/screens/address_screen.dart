import 'dart:async';
import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shop_app/common/widgets/big_text.dart';
import 'package:shop_app/common/widgets/custom_button.dart';
import 'package:shop_app/common/widgets/custom_textfield.dart';
import 'package:shop_app/config/payment_configurations.dart';
import 'package:shop_app/constains/global_variables.dart';
import 'package:shop_app/constains/utils.dart';
import 'package:shop_app/features/address/services/address_services.dart';
import 'package:shop_app/models/user_model.dart';
import 'package:shop_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
// import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// bien theo doi radio
enum paymentMethod {
  cash,
  stripe,
}

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

  paymentMethod _payment = paymentMethod.cash;

  // Declare user variable at the class level
  late UserProvider userProvider;
  late User user;

  //địa chỉ được sửa dụng
  String addressToBeUsed = "";
  String phoneToBeUsed = "";
  String selectedPaymentMethod = "";

  Map<String, dynamic>? paymentIntent;

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
    // Initialize userProvider using Provider.of
    userProvider = Provider.of<UserProvider>(context, listen: false);
    // Optionally, you can also initialize the user variable here if needed
    user = userProvider.user;
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

  //thanh toán
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

  //phuong thuc thanh toan
  Future<void> showPaymentMethodDialog() async {
    String? selectedPaymentMethod;

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Payment Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //nut radio Sign Up
              ListTile(
                title: const Text(
                  'Cash on Delivery',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Radio(
                  activeColor: GlobalVariables.secondaryColor,
                  value: paymentMethod.cash,
                  groupValue: _payment,
                  onChanged: (paymentMethod? val) {
                    setState(() {
                      _payment = val!;
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text(
                  'Stripe',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Radio(
                  activeColor: GlobalVariables.secondaryColor,
                  value: paymentMethod.stripe,
                  groupValue: _payment,
                  onChanged: (paymentMethod? val) {
                    setState(() {
                      _payment = val!;
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    setState(() {
      this.selectedPaymentMethod =
          selectedPaymentMethod ?? this.selectedPaymentMethod;
    });
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent(widget.totalAmount, 'USD');

      var gpay = const PaymentSheetGooglePay(
          merchantCountryCode: "US", currencyCode: "USD", testEnv: true);

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.light,
                  merchantDisplayName: 'Abhi',
                  googlePay: gpay))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      print(err);
    }
  }

  // displayPaymentSheet() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet().then((value) {
  //       print("Payment Successfully");
  //     });
  //   } catch (e) {
  //     print('Flase');
  //   }
  // }

  Future<void> displayPaymentSheet() async {
    try {
      // Ensure userProvider is initialized before using it
      if (userProvider != null) {
        user = userProvider.user;
      } else {
        // Handle the case where userProvider is null or not initialized
        print("UserProvider is null or not initialized");
        return;
      }

      await Stripe.instance.presentPaymentSheet().then((value) {
        print("Payment Successfully");
        // Call payPressed function here
        payPressed(user.address, user.phone);
      });
    } catch (e, stackTrace) {
      print('Error in displayPaymentSheet: $e');
      print(stackTrace);
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51OAz42JmIpBKLti4QMyZe6hvskqMVmZGURDO6qZYb67iItJCm3QpAO2CcwhdNi7xOcf3O0FTtzq3ju37FyQtyZkC00qe3EnRFu',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
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

              SizedBox(height: 10),
              // Button to show payment method selection dialog
              GestureDetector(
                onTap: () async {
                  showPaymentMethodDialog();
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.black,
                      width: 0.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BigText(
                          text: "Payment Method: ",
                          size: 16,
                        ),
                        if (_payment == paymentMethod.cash)
                          BigText(
                            text: "Cash on Delivery",
                            size: 16,
                          )
                        else if (_payment == paymentMethod.stripe)
                          BigText(
                            text: "Stripe",
                            size: 16,
                          )
                      ],
                    ),
                  ),
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
                  onTap: () async {
                    if (_payment == paymentMethod.cash) {
                      payPressed(user.address, user.phone);
                    } else if (_payment == paymentMethod.stripe) {
                      await makePayment();
                      // payPressed(user.address, user.phone);
                    }
                  },
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
