// lib/main.dart
//
// Entry point.
// Sets up:
//   • Provider tree (QuoteProvider is created here and never recreated)
//   • MaterialApp with custom theme
//   • QuoteScreen as the home

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/quote_provider.dart';
import 'screens/quote_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();


  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);


  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const RandomQuoteApp());
}

class RandomQuoteApp extends StatelessWidget {
  const RandomQuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // create is called once; the provider lives as long as the widget tree.
      create: (_) => QuoteProvider(),
      child: MaterialApp(
        title: 'Daily Wisdom',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        home: const QuoteScreen(),
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      // Warm off-white scaffold — matches the screen background.
      scaffoldBackgroundColor: const Color(0xFFF5F0E8),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFD4A96A),
        brightness: Brightness.light,
      ),
      // Remove any default splash/ink effects for a cleaner Apple-like feel.
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    );
  }
}
