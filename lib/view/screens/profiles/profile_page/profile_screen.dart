// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/provider/account_provider.dart';
import 'package:sharing_cafe/provider/user_profile_provider.dart';
import 'package:sharing_cafe/view/screens/auth/complete_profile/complete_profile_screen.dart';
import 'package:sharing_cafe/view/screens/auth/complete_profile/select_interest_screen.dart';
import 'package:sharing_cafe/view/screens/auth/login/login_screen.dart';
import 'package:sharing_cafe/view/screens/events/my_event/my_event_screen.dart';
import 'package:sharing_cafe/view/screens/profiles/preview_my_profile/preview_my_profile_screen.dart';
import 'package:sharing_cafe/view/screens/profiles/profile_page/components/profile_menu.dart';
import 'package:sharing_cafe/view/screens/profiles/update_profile/update_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<UserProfileProvider>(context, listen: false)
        .getUserProfile()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final accountService = Provider.of<AccountProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/cafe.png',
              height: 20,
            ),
            const SizedBox(
              width: 8,
            ),
            Text('Hồ sơ', style: heading2Style.copyWith(color: kPrimaryColor)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Consumer<UserProfileProvider>(builder: (context, value, child) {
              var userProfile = value.userProfile;
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(userProfile.profileAvatar,
                                  fit: BoxFit.cover))),
                      const SizedBox(height: 10),
                      Text(
                        userProfile.userName,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(userProfile.story ?? "",
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, UpdateProfileScreen.routeName);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  side: BorderSide.none,
                                  shape: const StadiumBorder()),
                              child: const Text("Chỉnh sửa",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, PreviewMyProfileScreen.routeName);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  side: BorderSide.none,
                                  shape: const StadiumBorder()),
                              child: const Text("Xem trước",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Divider(),
                      const SizedBox(height: 10),

                      //MENU
                      ProfileMenu(
                          title: "Sự kiện của bạn",
                          icon: LineAwesomeIcons.calendar_check,
                          onPress: () {
                            Navigator.pushNamed(
                                context, MyEventScreen.routeName);
                          }),
                      ProfileMenu(
                          title: "Blog của bạn",
                          icon: LineAwesomeIcons.blog,
                          onPress: () {}),
                      ProfileMenu(
                          title: "Sở thích của bạn",
                          icon: LineAwesomeIcons.ice_cream,
                          onPress: () {
                            Navigator.pushNamed(
                                context, SelectInterestScreen.routeName);
                          }),
                      ProfileMenu(
                          title: "Hoàn thiện hồ sơ",
                          icon: LineAwesomeIcons.candy_cane,
                          onPress: () {
                            Navigator.pushNamed(
                                context, CompleteProfileScreen.routeName);
                          }),
                      const Divider(color: Colors.grey),
                      // ProfileMenu(
                      //     title: "Thời tiết",
                      //     icon: LineAwesomeIcons.cloud_with_sun,
                      //     onPress: () {}),
                      ProfileMenu(
                          title: "Logout",
                          icon: LineAwesomeIcons.alternate_sign_out,
                          textColor: Colors.red,
                          endIcon: false,
                          onPress: () async {
                            try {
                              await accountService.logout();
                            } catch (e) {
                              return;
                            }
                            Navigator.pushNamedAndRemoveUntil(context,
                                LoginScreen.routeName, (route) => false);
                          }),
                    ],
                  ),
                ),
              );
            }),
    );
  }
}
