import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:il_app/logic/vm/user_page_view_model.dart';
import 'package:il_app/ui/widgets/navigation_drawer.dart';
import 'package:provider/provider.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User'),
      ),
      drawer: const AppNavigationDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: ChangeNotifierProvider(
          create: (context) => UserPageViewModel(
            navigateToLoginPage: () => context.pushReplacement('/login'),
          ),
          child: Consumer<UserPageViewModel>(
            builder: (context, model, child) {
              var titleTextStyle = Theme.of(context).textTheme.titleLarge;
              var bodyTextStyle = Theme.of(context).textTheme.bodyLarge;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  Text('User', style: titleTextStyle),
                  Text(model.user.fullName, style: bodyTextStyle),
                  const SizedBox(height: 20),
                  //
                  Text('Email', style: titleTextStyle),
                  Text(model.user.email, style: bodyTextStyle),
                  const SizedBox(height: 20),
                  //
                  Text('Contact', style: titleTextStyle),
                  Text(model.user.contact, style: bodyTextStyle),
                  const SizedBox(height: 20),
                  //
                  Text('Role', style: titleTextStyle),
                  Text(model.user.role.name, style: bodyTextStyle),
                  const SizedBox(height: 40),
                  //
                  FilledButton(
                    onPressed: () => model.logout(),
                    child: const Text('Log out'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}