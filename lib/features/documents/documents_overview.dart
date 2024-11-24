import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show SliverConstraints;
import 'package:provider/provider.dart';

import '../../entities/document.dart';
import 'document_editor.dart';
import 'documents_store.dart';

class DocumentsOverviewSliver extends StatelessWidget {
  const DocumentsOverviewSliver({super.key});

  @override
  Widget build(BuildContext context) {
    final documents = context.watch<DocumentsStore>().documents;

    if (documents.isEmpty) {
      // TODO: empty documents view
      return const SliverToBoxAdapter();
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
