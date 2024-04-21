import 'package:flutter/material.dart';

import '../../constants.dart';
import '../screens/auth/register/register_screen.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Bạn không có tài khoản ư? ",
          style: TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, RegisterScreen.routeName),
          child: const Text(
            "Đăng ký ngay",
            style: TextStyle(fontSize: 16, color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
