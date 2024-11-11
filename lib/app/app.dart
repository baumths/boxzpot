import 'package:flutter/material.dart';

import '../features/boxes/boxes_overview.dart';

class BoxzpotApp extends StatelessWidget {
  const BoxzpotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Boxzpot',
      theme: ThemeData.dark(),
      home: const BoxesOverview(),
    );
  }
}
