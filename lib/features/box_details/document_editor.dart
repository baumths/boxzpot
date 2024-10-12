import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/box.dart';
import 'box_details_store.dart';

typedef DocumntEditorResult = ({
  String code,
  String title,
  String date,
  String accessPoints,
});

class DocumentEditor extends StatefulWidget {
  const DocumentEditor({
    super.key,
    required this.document,
    required this.onDismissed,
    required this.onSubmitted,
  });

  final Document? document;
  final VoidCallback onDismissed;
  final ValueChanged<DocumntEditorResult> onSubmitted;

  static void show(BuildContext context, {Document? document}) async {
    final store = context.read<BoxDetailsStore>();

    final result = await showDialog<DocumntEditorResult>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: DocumentEditor(
          document: document,
          onDismissed: () => Navigator.pop(context),
          onSubmitted: (DocumntEditorResult result) {
            Navigator.pop(context, result);
          },
        ),
      ),
    );

    if (result == null) return;

    if (document == null) {
      store.addDocument(
        code: result.code,
        title: result.title,
        date: result.date,
        accessPoints: result.accessPoints,
      );
    } else {
      store.updateDocument(
        documentId: document.id,
        title: result.title,
        code: result.code,
        date: result.date,
        accessPoints: result.accessPoints,
      );
    }
  }

  @override
  State<DocumentEditor> createState() => DocumentEditorState();
}

class DocumentEditorState extends State<DocumentEditor> {
  final formKey = GlobalKey<FormState>();

  late var code = widget.document?.code ?? '';
  late var title = widget.document?.title ?? '';
  late var date = widget.document?.date ?? '';
  late var accessPoints = widget.document?.accessPoints ?? '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: SizedBox(
        width: 600,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.document == null ? 'New Document' : 'Editing Document',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: code,
                decoration: const InputDecoration(
                  labelText: 'Code',
                  helperText: 'Mandatory field.',
                ),
                validator: (value) {
                  if (value != null) {
                    value = value.trim();
                    if (value.isEmpty) {
                      return 'Code must not be empty.';
                    }
                  }
                  return null;
                },
                onSaved: (value) => code = value?.trim() ?? '',
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  helperText: 'Mandatory field.',
                ),
                validator: (value) {
                  if (value != null) {
                    value = value.trim();
                    if (value.isEmpty) {
                      return 'Title must not be empty.';
                    }
                  }
                  return null;
                },
                onSaved: (value) => title = value?.trim() ?? '',
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: date,
                decoration: const InputDecoration(
                  labelText: 'Date',
                ),
                onSaved: (value) => date = value?.trim() ?? '',
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: accessPoints,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Access Points',
                ),
                onSaved: (value) => accessPoints = value?.trim() ?? '',
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onDismissed,
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        formKey.currentState!.save();
                        widget.onSubmitted((
                          code: code,
                          title: title,
                          date: date,
                          accessPoints: accessPoints,
                        ));
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
