import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/box.dart';
import '../../localization/generated/app_localizations.dart';
import '../../shared/responsive_dialog.dart';
import 'boxes_store.dart';

typedef BoxEditorResult = ({String code, String name, String description});

class BoxEditor extends StatefulWidget {
  const BoxEditor({
    super.key,
    required this.box,
    required this.onDismissed,
    required this.onSubmitted,
  });

  final Box? box;
  final VoidCallback onDismissed;
  final ValueChanged<BoxEditorResult> onSubmitted;

  static void show(BuildContext context, {Box? box}) async {
    final store = context.read<BoxesStore>();

    final result = await showDialog<BoxEditorResult>(
      context: context,
      builder: (BuildContext context) => ResponsiveDialog(
        child: BoxEditor(
          key: const GlobalObjectKey('ModalBoxEditor'),
          box: box,
          onDismissed: () => Navigator.pop(context),
          onSubmitted: (BoxEditorResult result) {
            Navigator.pop(context, result);
          },
        ),
      ),
    );

    if (result == null) return;

    if (box == null) {
      store.createBox(
        code: result.code,
        name: result.name,
        description: result.description,
      );
    } else {
      store.updateBox(
        boxId: box.id,
        name: result.name,
        code: result.code,
        description: result.description,
      );
    }
  }

  @override
  State<BoxEditor> createState() => BoxEditorState();
}

class BoxEditorState extends State<BoxEditor> {
  final formKey = GlobalKey<FormState>();

  late var code = widget.box?.code ?? '';
  late var name = widget.box?.name ?? '';
  late var description = widget.box?.description ?? '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Form(
      autovalidateMode: AutovalidateMode.onUnfocus,
      key: formKey,
      child: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.box == null
                    ? l10n.newBoxFormHeaderTitle
                    : l10n.editBoxFormHeaderTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: code,
                decoration: InputDecoration(
                  labelText: l10n.boxCodeFormFieldLabel,
                ),
                validator: (value) {
                  if (value != null) {
                    value = value.trim();
                    if (value.isEmpty) {
                      return l10n.emptyFormFieldValidationMessage(
                        fieldLabel: l10n.boxCodeFormFieldLabel,
                      );
                    }
                  }
                  return null;
                },
                onSaved: (value) => code = value?.trim() ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(
                  labelText: l10n.boxNameFormFieldLabel,
                ),
                validator: (value) {
                  if (value != null) {
                    value = value.trim();
                    if (value.isEmpty) {
                      return l10n.emptyFormFieldValidationMessage(
                        fieldLabel: l10n.boxNameFormFieldLabel,
                      );
                    }
                  }
                  return null;
                },
                onSaved: (value) => name = value?.trim() ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: description,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: l10n.boxDescriptionFormFieldLabel,
                ),
                onSaved: (value) => description = value?.trim() ?? '',
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                          name: name,
                          description: description,
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
