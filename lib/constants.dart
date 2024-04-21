import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFFA4634D);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFA4634D), Color(0xFFAC7E6E)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Colors.black;
const kButtonColor = Color(0xFFF6EFED);
const kFormFieldColor = Color(0xFFFAFAFA);
const kErrorColor = Color.fromARGB(255, 214, 38, 38);

const kAnimationDuration = Duration(milliseconds: 200);

const headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const heading2Style = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Bạn cần nhập email để tiếp tục";
const String kInvalidEmailError = "Hãy nhập email hợp lệ";
const String kPassNullError = "Bạn cần nhập mật khẩu để tiếp tục";
const String kShortPassError = "Mật khẩu quá ngắn";
const String kMatchPassError = "Mật khẩu không khớp";
const String kNamelNullError = "Hãy nhập tên của bạn";
const String kPhoneNumberNullError = "Hãy nhập số điện thoại của bạn";
const String kAddressNullError = "Hãy nhập địa chỉ";

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 16),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: kTextColor),
  );
}
