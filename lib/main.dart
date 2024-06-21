import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';
import 'screens/home_screen.dart'; // Sesuaikan jalur impor ini

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, notifier, child) {
          return MaterialApp(
            title: 'Music Player',
            theme: notifier.darkTheme ? ThemeData.dark() : ThemeData.light(),
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
