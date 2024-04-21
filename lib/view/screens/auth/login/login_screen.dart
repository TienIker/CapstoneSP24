// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/helper/keyboard.dart';
import 'package:sharing_cafe/provider/account_provider.dart';
import 'package:sharing_cafe/view/components/form_error.dart';
import 'package:sharing_cafe/view/screens/auth/confirm_email/confirm_email_screen.dart';
import 'package:sharing_cafe/view/screens/auth/forgot_password/forgot_password_screen.dart';
import 'package:sharing_cafe/view/screens/init_screen.dart';

import '../../../components/no_account_text.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  bool showText = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final accountService = Provider.of<AccountProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Sharing Café",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "\n",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (newValue) => email = newValue,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              removeError(error: kEmailNullError);
                            } else if (emailValidatorRegExp.hasMatch(value)) {
                              removeError(error: kInvalidEmailError);
                            }
                            return;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              addError(error: kEmailNullError);
                              return "";
                            } else if (!emailValidatorRegExp.hasMatch(value)) {
                              addError(error: kInvalidEmailError);
                              return "";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            //labelText: "Email",
                            hintText: "Email",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            // suffixIcon: CustomSurffixIcon(
                            //     svgIcon: "assets/icons/Mail.svg"),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          obscureText: showText ? false : true,
                          onSaved: (newValue) => password = newValue,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              removeError(error: kPassNullError);
                            } else if (value.length >= 4) {
                              removeError(error: kShortPassError);
                            }
                            return;
                          },
                          obscuringCharacter: "*",
                          validator: (value) {
                            if (value!.isEmpty) {
                              addError(error: kPassNullError);
                              return "";
                            } else if (value.length < 4) {
                              addError(error: kShortPassError);
                              return "";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Mật khẩu",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showText = !showText;
                                  });
                                },
                                icon: Icon(showText
                                    ? Icons.visibility
                                    : Icons.visibility_off)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            // Checkbox(
                            //   value: remember,
                            //   activeColor: kPrimaryColor,
                            //   onChanged: (value) {
                            //     setState(() {
                            //       remember = value;
                            //     });
                            //   },
                            // ),
                            //const Text("Remember me"),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, ForgotPasswordScreen.routeName),
                              child: const Text(
                                "Quên mật khẩu",
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        ),
                        FormError(errors: errors),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              try {
                                await accountService.login(emailController.text,
                                    passwordController.text);
                                // if all are valid then go to success screen
                                KeyboardUtil.hideKeyboard(context);
                              } catch (e) {
                                return;
                              }
                              var isConfirm =
                                  await accountService.confirmVerificationEmail(
                                      emailController.text,
                                      passwordController.text);
                              // if all are valid then go to success screen
                              if (isConfirm) {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    InitScreen.routeName, (route) => false);
                              } else {
                                Navigator.pushNamed(
                                    context, ConfirmEmailScreen.routeName,
                                    arguments: {
                                      "email": emailController.text,
                                      "password": passwordController.text
                                    });
                              }
                            }
                          },
                          child: const Text("Đăng nhập"),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 16),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     SocalCard(
                  //       icon: "assets/icons/google-icon.svg",
                  //       press: () {},
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 20),
                  const NoAccountText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
