import 'dart:math' as math show max;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/document.dart';
import 'document_editor.dart';
import 'documents_store.dart';

class DocumentsOverview extends StatelessWidget {
  const DocumentsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final documents = context.watch<DocumentsStore>().documents;

    if (documents.isEmpty) {
      return const SizedBox.shrink();
    }

    return ResponsiveDocumentsView(
      documents: documents,
      onDocumentPressed: (Document document) {
        DocumentEditor.show(context, document: document);
      },
    );
  }
}

class ResponsiveDocumentsView extends StatelessWidget {
  const ResponsiveDocumentsView({
    super.key,
    required this.documents,
    required this.onDocumentPressed,
  });

  final List<Document> documents;
  final ValueChanged<Document> onDocumentPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              for (final Document document in documents)
                ListTile(
                  title: Text(document.title),
                  subtitle: Text(document.code),
                  onTap: () => onDocumentPressed(document),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
            ],
          );
        }

        return GridView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: math.max(1, constraints.maxWidth ~/ 192),
            mainAxisExtent: 192,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          children: [
            for (final Document document in documents)
              DocumentCard(
                document: document,
                onPressed: () => onDocumentPressed(document),
              ),
          ],
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
            padding: const EdgeInsets.all(12).copyWith(top: 24),
            child: Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                widget.document.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 7,
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
