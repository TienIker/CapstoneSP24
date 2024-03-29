import 'package:fluttertoast/fluttertoast.dart';
import 'package:sharing_cafe/constants.dart';

final class ErrorHelper {
  static void showError({String message = "Có lỗi xảy ra!"}) {
    Fluttertoast.showToast(msg: message, textColor: kErrorColor);
  }
}
