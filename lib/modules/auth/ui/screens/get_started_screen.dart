import 'package:easyattend/core/router/app_router.dart';
import 'package:easyattend/core/themes/styles.dart';
import 'package:easyattend/core/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(flex: 2),
            Image.asset("assets/images/logo_big.png"),
            Spacer(flex: 2),

            Text(
              "Go and enjoy our features for free and make your life easy with us.\n",
              textAlign: TextAlign.center,
              style: Styles.normal17,
              
            ),
            SizedBox(height: 15),
            CustomElevatedButton(
              child: Text("Let\u2019s Start"),
              onPressed: () {
                context.push(AppRoutes.login);
              },
            ),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
