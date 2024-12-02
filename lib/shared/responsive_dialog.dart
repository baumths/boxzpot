import 'package:flutter/material.dart';

/// The [child] must have a [GlobalKey] to keep its state when the layout changes.
class ResponsiveDialog extends StatelessWidget {
  const ResponsiveDialog({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return switch (MediaQuery.sizeOf(context).width) {
      >= 1200 => Align(
          alignment: AlignmentDirectional.centerEnd,
          child: SizedBox(
            height: double.infinity,
            width: 512,
            child: Material(
              child: child,
            ),
          ),
        ), // SideSheet
      >= 900 => Dialog(child: child),
      _ => Dialog.fullscreen(child: child),
    };
  }
}
