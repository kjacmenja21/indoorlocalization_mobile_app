import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_theme.dart';

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var user = AuthenticationContext.currentUser!.user;

    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Theme(
          data: Theme.of(context).copyWith(
            listTileTheme: const ListTileThemeData(
              textColor: AppColors.primaryBlueColor,
              iconColor: AppColors.primaryBlueColor,
            ),
          ),
          child: Column(
            children: [
              ListTile(
                title: const Text('Home'),
                leading: const FaIcon(FontAwesomeIcons.house),
                onTap: () => context.pushReplacement('/home'),
              ),
              ListTile(
                title: const Text('Dashboard'),
                leading: const FaIcon(FontAwesomeIcons.solidMap),
                onTap: () => context.pushReplacement('/asset_dashboard'),
              ),
              ListTile(
                title: const Text('Assets'),
                leading: const FaIcon(FontAwesomeIcons.box),
                onTap: () => context.pushReplacement('/assets'),
              ),
              ListTile(
                title: const Text('Asset reports'),
                leading: const FaIcon(FontAwesomeIcons.solidChartBar),
                onTap: () => context.pushReplacement('/asset_reports'),
              ),
              const Spacer(),
              ListTile(
                title: Text(user.fullName),
                leading: const FaIcon(FontAwesomeIcons.solidUser),
                onTap: () => context.pushReplacement('/user'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
