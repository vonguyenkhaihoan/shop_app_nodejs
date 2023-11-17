import 'package:shop_app/features/account/service/account_services.dart';
import 'package:shop_app/features/account/widgets/account_button.dart';
import 'package:flutter/material.dart';

class TopButton extends StatelessWidget {
  const TopButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(text: "Your Oders", onTap: () {}),
            AccountButton(text: "Turn Seller", onTap: () {}),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            AccountButton(
                text: "Log Out",
                onTap: () => AccountServices().logOut(context)),
            AccountButton(text: "Your Wish List", onTap: () {}),
          ],
        ),
      ],
    );
  }
}
