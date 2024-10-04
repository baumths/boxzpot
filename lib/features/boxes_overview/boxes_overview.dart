import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          final result = await showDialog<(String, String, String)?>(
            context: context,
            builder: (context) {
              final formKey = GlobalKey<FormState>();
              var code = '', name = '', description = '';

              return Dialog(
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            'New Box',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Code',
                                helperText: 'Mandatory field.'),
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
                            decoration: const InputDecoration(
                                labelText: 'Name',
                                helperText: 'Mandatory field.'),
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
                            maxLines: null,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                            ),
                            onSaved: (value) =>
                                description = value?.trim() ?? '',
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () => Navigator.pop(context),
                              ),
                              FilledButton(
                                child: const Text('Save'),
                                onPressed: () {
                                  if (formKey.currentState?.validate() ??
                                      false) {
                                    formKey.currentState!.save();
                                    Navigator.pop(
                                      context,
                                      (code, name, description),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
          if (result == null) return;
          final (code, name, description) = result;
          store.createBox(code: code, name: name, description: description);
        },
      ),
    );
  }
}
