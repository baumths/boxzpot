import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../../entities/box.dart';
import '../../localization/generated/app_localizations.dart';
import '../documents/document_editor.dart';
import '../documents/documents_overview.dart';
import '../documents/documents_store.dart';
import 'box_editor.dart';
import 'box_store.dart';
import 'box_title.dart';

class BoxDetails extends StatelessWidget {
  const BoxDetails({super.key, required this.boxId});

  final int boxId;

  static void show(BuildContext context, Box box) {
    context.read<DocumentsStore>().updateBoxId(box.id);
    Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => BoxDetails(boxId: box.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BoxStore>(
      create: (BuildContext context) => BoxStore(
        boxesRepository: context.read(),
        boxId: boxId,
      ),
      child: const Material(
        child: BoxDetailsView(),
      ),
    );
  }
}

class BoxDetailsView extends StatelessWidget {
  const BoxDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final box = context.watch<BoxStore>().box;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= 700) {
          return const Row(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 16, 0, 16),
                child: SizedBox(
                  width: 300,
                  child: BoxDetailsSideBar(),
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    DocumentsOverviewSliver(),
                  ],
                ),
              ),
            ],
          );
        }
        return CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              title: BoxTitle(box: box),
              leading: IconButton(
                icon: const Icon(Icons.close),
                tooltip: AppLocalizations.of(context).closeBoxButtonLabel,
                onPressed: () => Navigator.pop(context),
              ),
              actions: const [
                BoxDetailsActionsBar(),
                SizedBox(width: 8),
              ],
              titleSpacing: 0,
            ),
            const DocumentsOverviewSliver(),
          ],
        );
      },
    );
  }
}

class BoxDetailsSideBar extends StatelessWidget {
  const BoxDetailsSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final box = context.watch<BoxStore>().box;

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      color: theme.colorScheme.surface,
      child: Column(
        spacing: 16,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: AppLocalizations.of(context).closeBoxButtonLabel,
                  onPressed: () => Navigator.pop(context),
                ),
                const BoxDetailsActionsBar(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: BoxTitle(
                box: box,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          if (box.description.isNotEmpty) ...[
            const Divider(height: 0),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(box.description),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class BoxDetailsActionsBar extends StatelessWidget {
  const BoxDetailsActionsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: l10n.newDocumentButtonLabel,
          icon: const Icon(Icons.note_add_outlined),
          onPressed: () => DocumentEditor.show(context),
        ),
        IconButton(
          tooltip: l10n.editBoxButtonLabel,
          icon: const Icon(Icons.edit_outlined),
          onPressed: () {
            BoxEditor.show(
              context,
              box: context.read<BoxStore>().box,
            );
          },
        ),
        IconButton(
          tooltip: l10n.viewBoxQrCodeButtonLabel,
          icon: const Icon(Icons.qr_code),
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (_) => Dialog(
                child: BoxQrCodeView(
                  box: context.read<BoxStore>().box,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class BoxQrCodeView extends StatefulWidget {
  const BoxQrCodeView({super.key, required this.box});

  final Box box;

  @override
  State<BoxQrCodeView> createState() => _BoxQrCodeViewState();
}

class _BoxQrCodeViewState extends State<BoxQrCodeView> {
  final buttonsVisualDensity = const VisualDensity(horizontal: 4, vertical: 4);
  final controller = WidgetsToImageController();

  var showBoxCode = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 312,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 24,
          children: [
            QrCodeCard(
              data: widget.box.hash,
              showDataAsSubtitle: showBoxCode,
              widgetsToImageController: controller,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const CloseButton(),
                IconButton(
                  onPressed: () => setState(() => showBoxCode = !showBoxCode),
                  tooltip: 'Box Code',
                  icon: showBoxCode
                      ? const Icon(Icons.subtitles)
                      : const Icon(Icons.subtitles_outlined),
                ),
                IconButton(
                  onPressed: download,
                  tooltip: AppLocalizations.of(context).downloadButtonLabel,
                  icon: const Icon(Icons.save_alt),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> download() async {
    final bytes = await controller.capture();
    if (bytes == null) return;

    final fileName = '${widget.box.hash}.png';
    final file = XFile.fromData(
      bytes,
      name: fileName,
      mimeType: 'image/png',
    );

    file.saveTo('./$fileName');
  }
}

class QrCodeCard extends StatelessWidget {
  const QrCodeCard({
    super.key,
    required this.data,
    required this.showDataAsSubtitle,
    required this.widgetsToImageController,
  });

  final String data;
  final bool showDataAsSubtitle;
  final WidgetsToImageController widgetsToImageController;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            spreadRadius: -2,
            color: Colors.grey,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: WidgetsToImage(
          controller: widgetsToImageController,
          child: Column(
            spacing: 12,
            children: [
              QrImageView(
                data: data,
                padding: EdgeInsets.zero,
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Colors.black,
                ),
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Colors.black,
                ),
              ),
              if (showDataAsSubtitle)
                Text(
                  data,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
