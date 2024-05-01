import 'package:flutter/widgets.dart';
import 'package:sharing_cafe/view/screens/appointment/appointment_history.dart';
import 'package:sharing_cafe/view/screens/auth/complete_profile/complete_profile_screen.dart';
import 'package:sharing_cafe/view/screens/auth/confirm_email/confirm_email_screen.dart';
import 'package:sharing_cafe/view/screens/blogs/all_blog/all_blog_screen.dart';
import 'package:sharing_cafe/view/screens/blogs/blog_categories.dart/blog_categories_screen.dart';
import 'package:sharing_cafe/view/screens/blogs/blog_category.dart/blog_category_screen.dart';
import 'package:sharing_cafe/view/screens/blogs/blog_detail/blog_detail_screen.dart';
import 'package:sharing_cafe/view/screens/blogs/blog_list/blog_list_screen.dart';
import 'package:sharing_cafe/view/screens/blogs/create_blog/create_blog_screen.dart';
import 'package:sharing_cafe/view/screens/blogs/my_blogs/my_blog_screen.dart';
import 'package:sharing_cafe/view/screens/blogs/search/search_blog_screen.dart';
import 'package:sharing_cafe/view/screens/chat/chat_screen.dart';
import 'package:sharing_cafe/view/screens/events/create_event/create_event_screen.dart';
import 'package:sharing_cafe/view/screens/events/event_detail/event_detail_screen.dart';
import 'package:sharing_cafe/view/screens/events/event_list/event_list_screen.dart';
import 'package:sharing_cafe/view/screens/events/my_event/my_event_screen.dart';
import 'package:sharing_cafe/view/screens/events/search/search_screen.dart';
import 'package:sharing_cafe/view/screens/friends/friends_screen.dart';
import 'package:sharing_cafe/view/screens/friends/pending_screen.dart';
import 'package:sharing_cafe/view/screens/matching/swipe_screen.dart';
import 'package:sharing_cafe/view/screens/home/home_screen.dart';
import 'package:sharing_cafe/view/screens/notification/notification_screen.dart';
import 'package:sharing_cafe/view/screens/profiles/preview_my_profile/preview_my_profile_screen.dart';
import 'package:sharing_cafe/view/screens/profiles/profile_page/profile_screen.dart';
import 'package:sharing_cafe/view/screens/profiles/update_profile/update_profile_screen.dart';

import 'view/screens/auth/complete_profile/select_interest_screen.dart';
import 'view/screens/auth/forgot_password/forgot_password_screen.dart';
import 'view/screens/init_screen.dart';
import 'view/screens/auth/otp/otp_screen.dart';
import 'view/screens/auth/login/login_screen.dart';
import 'view/screens/auth/register/register_screen.dart';
import 'view/screens/auth/splash/splash_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  InitScreen.routeName: (context) => const InitScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  SelectInterestScreen.routeName: (context) => const SelectInterestScreen(),
  OtpScreen.routeName: (context) => const OtpScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  UpdateProfileScreen.routeName: (context) => const UpdateProfileScreen(),
  PreviewMyProfileScreen.routeName: (context) => const PreviewMyProfileScreen(),
  EventListScreen.routeName: (context) => const EventListScreen(),
  EventDetailScreen.routeName: (context) => const EventDetailScreen(),
  CreateEventScreen.routeName: (context) => const CreateEventScreen(),
  MyEventScreen.routeName: (context) => const MyEventScreen(),
  SearchScreen.routeName: (context) => const SearchScreen(),
  BlogListScreen.routeName: (context) => const BlogListScreen(),
  AllBlogScreen.routeName: (context) => const AllBlogScreen(),
  BlogCategoriesScreen.routeName: (context) => const BlogCategoriesScreen(),
  BlogCategoryScreen.routeName: (context) => const BlogCategoryScreen(),
  BlogDetailScreen.routeName: (context) => const BlogDetailScreen(),
  CreateBlogScreen.routeName: (context) => const CreateBlogScreen(),
  SwipeScreen.routeName: (context) => const SwipeScreen(),
  FriendsScreen.routeName: (context) => const FriendsScreen(),
  ChatScreen.routeName: (context) => const ChatScreen(),
  ConfirmEmailScreen.routeName: (context) => const ConfirmEmailScreen(),
  PendingScreen.routeName: (context) => const PendingScreen(),
  NotificationScreen.routeName: (context) => const NotificationScreen(),
  AppointmentHistoryScreen.routeName: (context) =>
      const AppointmentHistoryScreen(),
  MyBlogScreen.routeName: (context) => const MyBlogScreen(),
  SearchBlogScreen.routeName: (context) => const SearchBlogScreen(),
};
