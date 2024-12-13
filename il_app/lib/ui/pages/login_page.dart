import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:il_app/logic/services/session_service.dart';
import 'package:il_app/logic/vm/login_page_view_model.dart';
import 'package:il_app/ui/widgets/app_logo.dart';
import 'package:il_app/ui/widgets/message_card.dart';
import 'package:il_basic_auth/il_basic_auth.dart';
import 'package:il_ws/il_ws.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: ChangeNotifierProvider(
        create: (context) => LoginPageViewModel(
          sessionService: SessionService(),
          loginHandler: BasicLoginHandler(AuthenticationService()),
          navigateToHomePage: () => context.pushReplacement('/home'),
        ),
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return Consumer<LoginPageViewModel>(
      builder: (context, model, child) {
        var body = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLogoWidget(),
            const SizedBox(height: 80),
            TextField(
              controller: model.tcUsername,
              decoration: const InputDecoration(
                label: Text('Username'),
                isDense: true,
                border: OutlineInputBorder(),
              ),
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: model.tcPassword,
              decoration: InputDecoration(
                label: const Text('Password'),
                isDense: true,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () => model.togglePasswordVisibility(),
                  icon: !model.showPassword ? const FaIcon(FontAwesomeIcons.solidEye) : const FaIcon(FontAwesomeIcons.solidEyeSlash),
                ),
              ),
              obscureText: !model.showPassword,
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.done,
            ),
            if (model.message != null)
              MessageCard(
                message: model.message!,
                onClose: () => model.clearMessage(),
              ),
            const SizedBox(height: 40),
            if (model.isLoading) const CircularProgressIndicator(),
            if (!model.isLoading)
              FilledButton(
                onPressed: () => model.login(),
                child: const Text('Log in'),
              ),
          ],
        );

        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: body,
            ),
          ),
        );
      },
    );
  }
}
