import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/box.dart';
import 'box_details_store.dart';
import 'box_item_editor.dart';

class BoxItems extends StatelessWidget {
  const BoxItems({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.select<BoxDetailsStore, List<BoxItem>>(
      (store) => store.items,
    );

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        for (final BoxItem item in items)
          ListTile(
            title: Text(item.title),
            subtitle: Text(item.code),
            onTap: () => BoxItemEditor.show(context, item: item),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
      ],
    );
  }
}
