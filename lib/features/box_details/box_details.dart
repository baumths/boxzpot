import 'package:flutter/material.dart';

import '../../entities/box.dart';

class BoxDetails extends StatelessWidget {
  const BoxDetails({super.key, required this.box});

  final Box box;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '#${box.hash}',
          style: theme.textTheme.titleMedium,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          // QR CODE
          IconTheme(
            data: IconThemeData(
              color: theme.colorScheme.primary,
            ),
            child: const Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.location_pin, size: 64),
                Icon(Icons.check_box_outline_blank_rounded, size: 128),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Text('Code', style: labelStyle),
          Text(box.code, style: theme.textTheme.bodyLarge),

          const SizedBox(height: 16),
          Text('Name', style: labelStyle),
          Text(box.name, style: theme.textTheme.bodyLarge),

          const SizedBox(height: 16),
          Text('Description', style: labelStyle),
          Text(
            box.description.isEmpty ? '---' : box.description,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
