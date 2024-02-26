import 'package:flutter/widgets.dart';
//import 'package:sharing_cafe/view/screens/home/home_screen.dart';

import 'view/screens/complete_profile/complete_profile_screen.dart';
import 'view/screens/forgot_password/forgot_password_screen.dart';
import 'view/screens/init_screen.dart';
import 'view/screens/otp/otp_screen.dart';
//import 'view/screens/profile/profile_screen.dart';
import 'view/screens/sign_in/sign_in_screen.dart';
import 'view/screens/sign_up/sign_up_screen.dart';
import 'view/screens/splash/splash_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  InitScreen.routeName: (context) => const InitScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  OtpScreen.routeName: (context) => const OtpScreen(),
  //HomeScreen.routeName: (context) => const HomeScreen(),
  //ProfileScreen.routeName: (context) => const ProfileScreen(),
};
