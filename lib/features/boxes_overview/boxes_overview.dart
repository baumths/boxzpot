import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../box_editor/box_editor.dart';
import 'boxes_store.dart';

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
              title: Text('${box.code} - ${box.name}'),
              subtitle: Text(box.hash),
              trailing: const Icon(Icons.arrow_right_rounded),
              onTap: () {
                // TODO: navigate to box details
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await showDialog<BoxEditorResult?>(
            context: context,
            builder: (context) {
              return Dialog(
                child: BoxEditor(
                  box: null,
                  onSubmitted: (result) => Navigator.pop(context, result),
                  onDismissed: () => Navigator.pop(context),
                ),
              );
            },
          );
          if (result == null) return;
          store.createBox(
            code: result.code,
            name: result.name,
            description: result.description,
          );
        },
      ),
    );
  }
}
