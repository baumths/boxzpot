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

    return ListView(
      itemExtent: 400,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(24),
      children: [
        for (final Box box in store.boxes) BoxCard(box: box),
      ],
    );
  }
}

class BoxCard extends StatelessWidget {
  const BoxCard({super.key, required this.box});

  final Box box;

  @override
  Widget build(BuildContext context) {
    final border = Border.all(
      color: Theme.of(context).colorScheme.outlineVariant,
    );
    return Card.outlined(
      margin: const EdgeInsetsDirectional.only(end: 24),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).push<void>(
          MaterialPageRoute(builder: (_) => BoxDetails(boxId: box.id)),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: border,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
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
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: border,
                  shape: BoxShape.circle,
                ),
                child: const SizedBox.square(dimension: 64),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
