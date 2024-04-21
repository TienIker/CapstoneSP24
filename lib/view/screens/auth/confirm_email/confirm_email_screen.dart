// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/service/account_service.dart';
import 'package:sharing_cafe/view/screens/init_screen.dart';

class ConfirmEmailScreen extends StatefulWidget {
  static String routeName = "/confirmEmail";
  const ConfirmEmailScreen({super.key});

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Xác thực email",
          style: heading2Style,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Vui lòng kiểm tra email của bạn để xác thực tài khoản",
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                final Map arguments =
                    ModalRoute.of(context)!.settings.arguments as Map;
                var email = arguments["email"];
                var password = arguments["password"];
                var isConfirm = await AccountService()
                    .confirmVerificationEmail(email, password);
                // if all are valid then go to success screen
                if (isConfirm) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Xác thực thành công"),
                    ),
                  );
                  Navigator.pushNamedAndRemoveUntil(
                      context, InitScreen.routeName, (route) => false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Email chưa được xác thực"),
                    ),
                  );
                }
              },
              child: const Text("Kiểm tra"),
            ),
          ],
        ),
      ),
    );
  }
}
