import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/document.dart';
import '../../localization/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
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
            spacing: 12,
            children: [
              Text(
                widget.document == null
                    ? l10n.newDocumentFormHeaderTitle
                    : l10n.editDocumentFormHeaderTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(),
              TextFormField(
                initialValue: code,
                decoration: InputDecoration(
                  labelText: l10n.documentCodeFormFieldLabel,
                ),
                validator: (value) {
                  if (value != null) {
                    value = value.trim();
                    if (value.isEmpty) {
                      return l10n.emptyFormFieldValidationMessage(
                        fieldLabel: l10n.documentCodeFormFieldLabel,
                      );
                    }
                  }
                  return null;
                },
                onSaved: (value) => code = value?.trim() ?? '',
              ),
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(
                  labelText: l10n.documentTitleFormFieldLabel,
                ),
                validator: (value) {
                  if (value != null) {
                    value = value.trim();
                    if (value.isEmpty) {
                      return l10n.emptyFormFieldValidationMessage(
                        fieldLabel: l10n.documentTitleFormFieldLabel,
                      );
                    }
                  }
                  return null;
                },
                onSaved: (value) => title = value?.trim() ?? '',
              ),
              TextFormField(
                initialValue: date,
                decoration: InputDecoration(
                  labelText: l10n.documentDateFormFieldLabel,
                ),
                onSaved: (value) => date = value?.trim() ?? '',
              ),
              TextFormField(
                initialValue: accessPoints,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: l10n.documentAccessPointsFormFieldLabel,
                ),
                onSaved: (value) => accessPoints = value?.trim() ?? '',
              ),
              const SizedBox(),
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
                    child: Text(l10n.cancelButtonLabel),
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
                    child: Text(l10n.saveButtonLabel),
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
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.deleteConfirmationDialogTitle),
      content: Text(l10n.deleteConfirmationDialogContent),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(l10n.cancelButtonLabel),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(l10n.saveButtonLabel),
        ),
      ],
    );
  }
}
