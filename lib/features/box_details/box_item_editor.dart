import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/box.dart';
import 'box_details_store.dart';

typedef BoxItemEditorResult = ({
  String code,
  String title,
  String date,
  String accessPoints,
});

class BoxItemEditor extends StatefulWidget {
  const BoxItemEditor({
    super.key,
    required this.item,
    required this.onDismissed,
    required this.onSubmitted,
  });

  final BoxItem? item;
  final VoidCallback onDismissed;
  final ValueChanged<BoxItemEditorResult> onSubmitted;

  static void show(BuildContext context, {BoxItem? item}) async {
    final store = context.read<BoxDetailsStore>();

    final result = await showDialog<BoxItemEditorResult>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: BoxItemEditor(
          item: item,
          onDismissed: () => Navigator.pop(context),
          onSubmitted: (BoxItemEditorResult result) {
            Navigator.pop(context, result);
          },
        ),
      ),
    );

    if (result == null) return;

    if (item == null) {
      store.addItem(
        code: result.code,
        title: result.title,
        date: result.date,
        accessPoints: result.accessPoints,
      );
    } else {
      store.updateItem(
        itemId: item.id,
        title: result.title,
        code: result.code,
        date: result.date,
        accessPoints: result.accessPoints,
      );
    }
  }

  @override
  State<BoxItemEditor> createState() => BoxItemEditorState();
}

class BoxItemEditorState extends State<BoxItemEditor> {
  final formKey = GlobalKey<FormState>();

  late var code = widget.item?.code ?? '';
  late var title = widget.item?.title ?? '';
  late var date = widget.item?.date ?? '';
  late var accessPoints = widget.item?.accessPoints ?? '';

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
                widget.item == null ? 'New Item' : 'Editing Item',
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
