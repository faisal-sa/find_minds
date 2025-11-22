import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/authentication/presentation/pages/forgot_password.dart';
import 'package:graduation_project/features/authentication/presentation/pages/login_page.dart';
import 'package:graduation_project/features/authentication/presentation/pages/signup_page.dart';
import 'package:graduation_project/features/profile/presentation/pages/profile_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return LoginPage();
      },
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) {
        return SignUpPage();
      },
    ),
    GoRoute(
      path: '/forgot_password',
      builder: (context, state) {
        return ForgotPasswordPage();
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        return ProfilePage();
      },
    ),
  ],
);
