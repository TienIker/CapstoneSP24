// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/provider/account_provider.dart';
import 'package:sharing_cafe/view/components/form_error.dart';
import 'package:sharing_cafe/view/screens/auth/complete_profile/complete_profile_screen.dart';
import 'package:sharing_cafe/view/screens/auth/confirm_email/confirm_email_screen.dart';

import '../../../../constants.dart';

class RegisterScreen extends StatefulWidget {
  static String routeName = "/register";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? userName;
  String? email;
  String? password;
  String? confirmPassword;
  bool remember = false;
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
  bool showTextConfirm = false;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final accountService = Provider.of<AccountProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text("Tạo tài khoản", style: headingStyle),
                  const Text(
                    "",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: userNameController,
                          onSaved: (newValue) => userName = newValue,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              removeError(error: kNamelNullError);
                            }
                            return;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              addError(error: kNamelNullError);
                              return "";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            //labelText: "Full Name",
                            hintText: "Họ và tên",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        const SizedBox(height: 20),
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
                            password = value;
                          },
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
                        TextFormField(
                          obscureText: showTextConfirm ? false : true,
                          onSaved: (newValue) => confirmPassword = newValue,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              removeError(error: kPassNullError);
                            } else if (value.isNotEmpty &&
                                password == confirmPassword) {
                              removeError(error: kMatchPassError);
                            }
                            confirmPassword = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              addError(error: kPassNullError);
                              return "";
                            } else if ((password != value)) {
                              addError(error: kMatchPassError);
                              return "";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Xác nhận mật khẩu",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showTextConfirm = !showTextConfirm;
                                  });
                                },
                                icon: Icon(showTextConfirm
                                    ? Icons.visibility
                                    : Icons.visibility_off)),
                          ),
                        ),
                        FormError(errors: errors),
                        const SizedBox(height: 20),
                        Consumer<AccountProvider>(
                          builder: (context, auth, child) => ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await accountService.register(
                                    userNameController.text.toString(),
                                    emailController.text.toString(),
                                    passwordController.text.toString());
                                try {
                                  var isConfirm = await accountService
                                      .confirmVerificationEmail(
                                          emailController.text,
                                          passwordController.text);
                                  // if all are valid then go to success screen
                                  if (isConfirm) {
                                    Navigator.pushNamed(context,
                                        CompleteProfileScreen.routeName);
                                  } else {
                                    Navigator.pushNamed(
                                        context, ConfirmEmailScreen.routeName,
                                        arguments: {
                                          "email": emailController.text,
                                          "password": passwordController.text
                                        });
                                  }
                                } catch (e) {
                                  return;
                                }
                              }
                            },
                            child: const Text("Tiếp tục"),
                          ),
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
                  // const SizedBox(height: 16),
                  // Text(
                  //   '',
                  //   textAlign: TextAlign.center,
                  //   style: Theme.of(context).textTheme.bodySmall,
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
