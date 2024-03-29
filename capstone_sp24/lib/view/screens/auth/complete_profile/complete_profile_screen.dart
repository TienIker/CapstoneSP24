// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/model/interest_model.dart';
import 'package:sharing_cafe/provider/interest_provider.dart';
import 'package:sharing_cafe/view/screens/auth/otp/otp_screen.dart';

import '../../../../constants.dart';

class CompleteProfileScreen extends StatefulWidget {
  static String routeName = "/complete_profile";
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  bool _isLoadingListInterests = false;
  List<InterestModel>? selectedHobby = [];

  @override
  void initState() {
    loadListInterests();
    super.initState();
  }

  void loadListInterests() {
    setState(() {
      _isLoadingListInterests = true;
    });
    Provider.of<InterestProvider>(context, listen: false)
        .getListInterests()
        .then((_) {
      setState(() {
        _isLoadingListInterests = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: _isLoadingListInterests
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : Consumer<InterestProvider>(builder: (context, value, child) {
                var listInterests = value.listInterests;
                return SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            const Text("Bạn thích điều gì?",
                                style: headingStyle),
                            const SizedBox(height: 16),
                            const Text(
                              "Hãy chọn sở thích của mình để có đề xuất tốt hơn nhé.",
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              children: listInterests.map(
                                (hobby) {
                                  bool isSelected = false;
                                  if (selectedHobby!.contains(hobby.name)) {
                                    isSelected = true;
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      if (!selectedHobby!
                                          .contains(hobby.name)) {
                                        if (selectedHobby!.length < 5) {
                                          selectedHobby!.add(hobby);
                                          setState(() {});
                                          print(selectedHobby);
                                        }
                                      } else {
                                        selectedHobby!.removeWhere(
                                            (element) => element == hobby.name);
                                        setState(() {});
                                        print(selectedHobby);
                                      }
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 4),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 12),
                                          decoration: BoxDecoration(
                                              color: isSelected
                                                  ? kPrimaryColor
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              border: Border.all(
                                                  color: isSelected
                                                      ? Colors.white
                                                      : kPrimaryColor,
                                                  width: 2)),
                                          child: Text(
                                            hobby.name,
                                            style: TextStyle(
                                                color: isSelected
                                                    ? Colors.white
                                                    : kPrimaryColor,
                                                fontSize: 14),
                                          ),
                                        )),
                                  );
                                },
                              ).toList(),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, OtpScreen.routeName);
                              },
                              child: const Text("Đăng ký"),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              "Bằng cách nhấp vào Đăng ký, bạn đồng ý \nvới Điều khoản và Điều kiện của chúng tôi",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }));
  }
}
