import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show SliverConstraints;
import 'package:provider/provider.dart';

import '../../entities/document.dart';
import '../../localization/generated/app_localizations.dart';
import 'document_editor.dart';
import 'documents_store.dart';

class DocumentsOverviewSliver extends StatelessWidget {
  const DocumentsOverviewSliver({super.key});

  @override
  Widget build(BuildContext context) {
    final documents = context.watch<DocumentsStore>().documents;

    if (documents.isEmpty) {
      return SliverFillRemaining(
        child: EmptyDocumentsView(
          onAddDocumentPressed: () => DocumentEditor.show(context),
        ),
      );
    }

    void onDocumentPressed(Document document) {
      DocumentEditor.show(context, document: document);
    }

    return SliverLayoutBuilder(
      builder: (BuildContext context, SliverConstraints constraints) {
        if (constraints.crossAxisExtent < 156 * 2) {
          return SliverList.list(
            children: [
              for (final Document document in documents)
                ListTile(
                  title: Text(document.title),
                  subtitle: Text(document.code),
                  onTap: () => onDocumentPressed(document),
                ),
            ],
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid.extent(
            maxCrossAxisExtent: 156,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              for (final Document document in documents)
                DocumentCard(
                  document: document,
                  onPressed: () => onDocumentPressed(document),
                ),
            ],
          ),
        );
      },
    );
  }
}

class EmptyDocumentsView extends StatelessWidget {
  const EmptyDocumentsView({super.key, required this.onAddDocumentPressed});

  final VoidCallback onAddDocumentPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '📄',
            style: TextStyle(
              fontSize: 128,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.boxDocumentsOverviewEmptyMessage,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onAddDocumentPressed,
            child: Text(l10n.addDocumentButtonLabel),
          ),
        ],
      ),
    );
  }
}

class DocumentCard extends StatefulWidget {
  const DocumentCard({
    super.key,
    required this.document,
    required this.onPressed,
  });

  final Document document;
  final VoidCallback onPressed;

  @override
  State<DocumentCard> createState() => _DocumentCardState();
}

class _DocumentCardState extends State<DocumentCard> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: CustomPaint(
          painter: isHovering
              ? _DocumentCardShapePainter(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 2.0,
                )
              : _DocumentCardShapePainter(
                  color: Theme.of(context).colorScheme.outline,
                  thickness: 0.5,
                ),
          child: Padding(
            padding: const EdgeInsets.all(12).copyWith(top: 32),
            child: Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                widget.document.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DocumentCardShapePainter extends CustomPainter {
  const _DocumentCardShapePainter({
    required this.color,
    required this.thickness,
  }) : assert(thickness >= 0.0);

  final Color color;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final foldWidth = 32.0 - thickness;
    canvas.drawPath(
      Path()
        ..moveTo(thickness, thickness)
        ..lineTo(size.width - foldWidth, thickness)
        ..lineTo(size.width - foldWidth, foldWidth)
        ..lineTo(size.width - thickness, foldWidth)
        ..lineTo(size.width - foldWidth, thickness)
        ..moveTo(size.width - thickness, foldWidth)
        ..lineTo(size.width - thickness, size.height - thickness)
        ..lineTo(thickness, size.height - thickness)
        ..lineTo(thickness, thickness),
      Paint()
        ..color = color
        ..strokeWidth = thickness
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_DocumentCardShapePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.thickness != thickness;
  }
}
