import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/provider/account_provider.dart';
import 'package:sharing_cafe/provider/blog_provider.dart';
import 'package:sharing_cafe/provider/categories_provider.dart';
import 'package:sharing_cafe/provider/chat_provider.dart';
import 'package:sharing_cafe/provider/event_provider.dart';
import 'package:sharing_cafe/provider/friends_provider.dart';
import 'package:sharing_cafe/provider/match_provider.dart';
import 'package:sharing_cafe/provider/home_provider.dart';
import 'package:sharing_cafe/provider/interest_provider.dart';
import 'package:sharing_cafe/provider/user_profile_provider.dart';
import 'package:sharing_cafe/service/location_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sharing_cafe/view/screens/auth/splash/splash_screen.dart';
import 'firebase_options.dart';

import 'routes.dart';
import 'theme.dart';

void main() async {
  // initialize firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print(message.data.toString());
    print(message.notification?.title);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    updateLocation();
    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      if (message != null) {
        if (kDebugMode) {
          print(message);
        }
      }
    });

    ///forground work
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      if (kDebugMode) {
        showNotification(message);
      }
    });
  }

  updateLocation() async {
    await LocationService().updateLocation();
  }

  void showNotification(RemoteMessage message) {
    if (message.notification != null) {
      var title = message.notification!.title.toString();
      var body = message.notification!.body.toString();
      if (kDebugMode) {
        print(message.notification!.body);
        print(message.notification!.title);
      }
      Get.snackbar(title, body,
          icon: Image.asset(
            'assets/images/cafe.png',
            height: 30,
            width: 30,
          ),
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.white.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => InterestProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => BlogProvider()),
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => MatchProvider()),
        ChangeNotifierProvider(create: (_) => FriendsProvider()),
        ChangeNotifierProvider(create: (_) => CategoriesProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sharing Cafe',
        theme: AppTheme.lightTheme(context),
        initialRoute: SplashScreen.routeName,
        routes: routes,
      ),
    );
  }
}
