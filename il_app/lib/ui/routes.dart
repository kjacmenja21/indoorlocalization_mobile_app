import 'package:go_router/go_router.dart';
import 'package:il_app/ui/pages/asset_dashboard_page.dart';
import 'package:il_app/ui/pages/assets_page.dart';
import 'package:il_app/ui/pages/entry_page.dart';
import 'package:il_app/ui/pages/home_page.dart';
import 'package:il_app/ui/pages/login_page.dart';
import 'package:il_app/ui/pages/user_page.dart';

final goRouter = GoRouter(
  initialLocation: '/entry',
  routes: [
    GoRoute(
      path: '/entry',
      builder: (context, state) => const EntryPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/asset_dashboard',
      builder: (context, state) => const AssetDashboardPage(),
    ),
    GoRoute(
      path: '/assets',
      builder: (context, state) => const AssetsPage(),
    ),
    GoRoute(
      path: '/user',
      builder: (context, state) => const UserPage(),
    ),
  ],
);
