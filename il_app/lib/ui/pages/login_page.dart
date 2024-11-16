import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:il_basic_auth/il_basic_auth.dart';
import 'package:il_core/il_core.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final tcUsername = TextEditingController();
  final tcPassword = TextEditingController();

  final loginHandler = BasicLoginHandler();
  bool showPassword = false;

  void togglePasswordVisibility() {
    setState(() => showPassword = !showPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: tcUsername,
              decoration: const InputDecoration(
                label: Text('Username'),
                border: OutlineInputBorder(),
              ),
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 40),
            TextField(
              controller: tcPassword,
              decoration: InputDecoration(
                label: const Text('Password'),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () => togglePasswordVisibility(),
                  icon: showPassword ? const FaIcon(FontAwesomeIcons.solidEye) : const FaIcon(FontAwesomeIcons.solidEyeSlash),
                ),
              ),
              obscureText: !showPassword,
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 40),
            FilledButton(
              onPressed: () {
                var username = tcUsername.text;
                var password = tcPassword.text;

                var token = BasicLoginToken(username, password);

                loginHandler.handleLogin(
                  baseToken: token,
                  loginListener: LoginOutcomeListener(
                    onSuccessfulLogin: (user) {
                      debugPrint('Success login ${user.username}');
                    },
                    onFailedLogin: (reason) {
                      debugPrint('Failed login $reason');
                    },
                  ),
                );
              },
              child: const Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    tcUsername.dispose();
    tcPassword.dispose();
    super.dispose();
  }
}
