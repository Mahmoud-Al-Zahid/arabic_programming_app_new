import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash/splash_screen.dart';
import 'themes/app_theme.dart';

void main() {
  runApp(const ArabicProgrammingApp());
}

class ArabicProgrammingApp extends StatefulWidget {
  const ArabicProgrammingApp({super.key});

  @override
  State<ArabicProgrammingApp> createState() => _ArabicProgrammingAppState();
}

class _ArabicProgrammingAppState extends State<ArabicProgrammingApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'تعلم البرمجة بالعربية',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      locale: const Locale('ar', 'SA'),
      home: SplashScreen(onThemeToggle: _toggleTheme),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );
  }
}
