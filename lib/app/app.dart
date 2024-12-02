import 'package:flutter/material.dart';

import '../features/boxes/boxes_overview.dart';

class BoxzpotApp extends StatelessWidget {
  const BoxzpotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Boxzpot',
      home: const BoxesOverview(),
      darkTheme: createTheme(Brightness.dark),
      theme: createTheme(Brightness.light),
      themeMode: ThemeMode.system,
    );
  }
}

ThemeData createTheme(Brightness brightness) {
  return ThemeData(
    brightness: brightness,
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
