import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/document.dart';
import '../../shared/responsive_dialog.dart';
import 'documents_store.dart';

typedef DocumentEditorResult = ({
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
  final ValueChanged<DocumentEditorResult> onSubmitted;

  static void show(BuildContext context, {Document? document}) async {
    final store = context.read<DocumentsStore>();

    final result = await showDialog<DocumentEditorResult>(
      context: context,
      builder: (BuildContext context) => ResponsiveDialog(
        child: DocumentEditor(
          key: const GlobalObjectKey('ModalDocumentEditor'),
          document: document,
          onDismissed: () => Navigator.pop(context),
          onSubmitted: (DocumentEditorResult result) {
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
        child: SingleChildScrollView(
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
                  if (widget.document != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded),
                      onPressed: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return DeleteConfirmationDialog(
                              onCancel: () => Navigator.pop(context, false),
                              onConfirm: () => Navigator.pop(context, true),
                            );
                          },
                        );
                        if (shouldDelete ?? false) {
                          if (context.mounted) {
                            context
                                .read<DocumentsStore>()
                                .deleteDocument(widget.document!.id);
                          }
                          widget.onDismissed();
                        }
                      },
                    ),
                  const Spacer(),
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

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({
    super.key,
    required this.onCancel,
    required this.onConfirm,
  });

  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you Sure?'),
      content: const Text('This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onConfirm,
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
