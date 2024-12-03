import 'package:flutter/material.dart';

import '../features/boxes/boxes_overview.dart';
import '../localization/generated/app_localizations.dart';

class BoxzpotApp extends StatelessWidget {
  const BoxzpotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Boxzpot',
      themeMode: ThemeMode.system,
      theme: createTheme(Brightness.light),
      darkTheme: createTheme(Brightness.dark),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const BoxesOverview(),
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
