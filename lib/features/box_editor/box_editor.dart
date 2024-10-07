import 'package:flutter/material.dart';

import '../../entities/box.dart';

typedef BoxEditorResult = ({String code, String name, String description});

class BoxEditor extends StatefulWidget {
  const BoxEditor({
    super.key,
    required this.box,
    required this.onSubmitted,
    required this.onDismissed,
  });

  final Box? box;
  final ValueChanged<BoxEditorResult> onSubmitted;
  final VoidCallback onDismissed;

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
    return Form(
      autovalidateMode: AutovalidateMode.onUnfocus,
      key: formKey,
      child: SizedBox(
        width: 600,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.box == null ? 'New Box' : 'Editing Box',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
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
                initialValue: name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  helperText: 'Mandatory field.',
                ),
                validator: (value) {
                  if (value != null) {
                    value = value.trim();
                    if (value.isEmpty) {
                      return 'Name must not be empty.';
                    }
                  }
                  return null;
                },
                onSaved: (value) => name = value?.trim() ?? '',
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: description,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                onSaved: (value) => description = value?.trim() ?? '',
              ),
              const SizedBox(height: 24),
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
                          name: name,
                          description: description,
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
