import 'package:flutter/material.dart';

import '../entities/box.dart';

class BoxTitle extends StatelessWidget {
  const BoxTitle({
    super.key,
    required this.box,
    this.overflow = TextOverflow.ellipsis,
    this.style,
  });

  final Box box;
  final TextOverflow? overflow;
  final TextStyle? style;

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
      style: style,
      overflow: overflow,
    );
  }
}
