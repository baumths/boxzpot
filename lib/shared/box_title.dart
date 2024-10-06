import 'package:flutter/material.dart';

import '../entities/box.dart';

class BoxTitle extends StatelessWidget {
  const BoxTitle({super.key, required this.box});

  final Box box;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: box.code,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(text: ' - '),
          TextSpan(text: box.name),
        ],
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}