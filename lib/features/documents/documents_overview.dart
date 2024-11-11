import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/document.dart';
import 'document_editor.dart';
import 'documents_store.dart';

class DocumentsOverview extends StatefulWidget {
  const DocumentsOverview({super.key, required this.boxId});

  final int boxId;

  @override
  State<DocumentsOverview> createState() => _DocumentsOverviewState();
}

class _DocumentsOverviewState extends State<DocumentsOverview> {
  @override
  void initState() {
    super.initState();
    context.read<DocumentsStore>().updateBoxId(widget.boxId);
  }

  @override
  void didUpdateWidget(covariant DocumentsOverview oldWidget) {
    super.didUpdateWidget(oldWidget);
    context.read<DocumentsStore>().updateBoxId(widget.boxId);
  }

  @override
  void dispose() {
    context.read<DocumentsStore>().updateBoxId(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const DocumentsList();
  }
}

class DocumentsList extends StatelessWidget {
  const DocumentsList({super.key});

  @override
  Widget build(BuildContext context) {
    final docs = context.watch<DocumentsStore>().documents;

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
