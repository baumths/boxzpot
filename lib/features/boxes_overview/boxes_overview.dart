import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/box.dart';
import '../../shared/box_title.dart';
import '../../shared/boxes_store.dart';
import '../box_details/box_details.dart';
import '../box_editor/box_editor.dart';

class BoxesOverview extends StatelessWidget {
  const BoxesOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const BoxesList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_box_rounded),
        onPressed: () => BoxEditor.show(context),
      ),
    );
  }
}

class BoxesList extends StatelessWidget {
  const BoxesList({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<BoxesStore>();

    if (store.boxes.isEmpty) {
      return Center(
        child: Text(
          '🗃️',
          style: TextStyle(
            fontSize: 128,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final (axis, extent) = switch (constraints.maxWidth) {
          >= 500 => (Axis.horizontal, 400.0),
          _ => (Axis.vertical, constraints.maxHeight - 100),
        };
        return ListView(
          itemExtent: extent,
          scrollDirection: axis,
          padding: const EdgeInsets.all(12),
          children: [
            for (final Box box in store.boxes) BoxCard(box: box),
          ],
        );
      },
    );
  }
}

class BoxCard extends StatelessWidget {
  const BoxCard({super.key, required this.box});

  final Box box;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      margin: const EdgeInsets.all(12),
      child: InkWell(
        onTap: () => BoxDetails.show(context, box),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: BoxLabel(box: box),
              ),
              const SizedBox(height: 24),
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const SizedBox.square(dimension: 64),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BoxLabel extends StatelessWidget {
  const BoxLabel({super.key, required this.box});

  final Box box;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: BoxTitle(
              box: box,
              overflow: TextOverflow.visible,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(box.description),
            ),
          ),
        ],
      ),
    );
  }
}
