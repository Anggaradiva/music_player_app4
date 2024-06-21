import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';

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
            theme: notifier.darkTheme ? dark : light,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}

final dark = ThemeData(
  brightness: Brightness.dark,
);

final light = ThemeData(
  brightness: Brightness.light,
);
