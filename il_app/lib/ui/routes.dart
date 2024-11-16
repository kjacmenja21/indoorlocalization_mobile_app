import 'package:go_router/go_router.dart';
import 'package:il_app/ui/pages/home_page.dart';
import 'package:il_app/ui/pages/login_page.dart';

final goRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);
