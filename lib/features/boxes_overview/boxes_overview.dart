import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/box_title.dart';
import '../../shared/boxes_store.dart';
import '../box_details/box_details.dart';
import '../box_editor/box_editor.dart';

class BoxesOverview extends StatelessWidget {
  const BoxesOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<BoxesStore>();
    return Scaffold(
      body: ListView(
        children: [
          for (final box in store.boxes)
            ListTile(
              title: BoxTitle(box: box),
              trailing: const Icon(Icons.arrow_right_rounded),
              onTap: () => Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (_) => BoxDetails(boxId: box.id),
                ),
              ),
              onLongPress: () => BoxEditor.show(context, box: box),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => BoxEditor.show(context),
      ),
    );
  }
}
