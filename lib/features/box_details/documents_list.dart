import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/document.dart';
import 'box_details_store.dart';
import 'document_editor.dart';

class DocumentsList extends StatelessWidget {
  const DocumentsList({super.key});

  @override
  Widget build(BuildContext context) {
    final docs = context.select<BoxDetailsStore, List<Document>>(
      (store) => store.documents,
    );

    if (docs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        for (final Document doc in docs)
          ListTile(
            title: Text(doc.title),
            subtitle: Text(doc.code),
            onTap: () => DocumentEditor.show(context, document: doc),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
      ],
    );
  }
}
