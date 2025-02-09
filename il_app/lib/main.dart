import 'package:flutter/material.dart';
import 'package:il_app/ui/routes.dart';
import 'package:il_core/il_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: goRouter,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          appBarTheme: const AppBarTheme(
            color: AppColors.primaryBlueColor,
            foregroundColor: Colors.white,
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryBlueColor,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
