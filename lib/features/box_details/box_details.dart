import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../../database/database.dart';
import '../../entities/box.dart';
import '../../shared/box_title.dart';
import '../box_editor/box_editor.dart';
import 'box_details_store.dart';
import 'document_editor.dart';
import 'documents_list.dart';

class BoxDetails extends StatelessWidget {
  const BoxDetails({super.key, required this.boxId});

  final int boxId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BoxDetailsStore>(
      create: (_) => BoxDetailsStore(
        database: context.read<AppDatabase>(),
        boxId: boxId,
      ),
      child: const BoxDetailsView(),
    );
  }
}

class BoxDetailsView extends StatelessWidget {
  const BoxDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Box'),
        actions: [
          IconButton(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => Dialog(
                child: BoxQrCodeView(
                  box: context.read<BoxDetailsStore>().box,
                ),
              ),
            ),
            icon: const Icon(Icons.qr_code),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BoxInfoCard(),
            SizedBox(height: 8),
            DocumentsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => DocumentEditor.show(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class BoxInfoCard extends StatelessWidget {
  const BoxInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final box = context.select<BoxDetailsStore, Box>((store) => store.box);
    return Card.outlined(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => BoxEditor.show(context, box: box),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BoxTitle(
                  box: box,
                  overflow: TextOverflow.visible,
                ),
                if (box.description.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(box.description),
                ],
              ],
            ),
          ),
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 256,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.box.hash,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            WidgetsToImage(
              controller: controller,
              child: QrImageView(
                data: widget.box.hash,
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.outlined(
                  onPressed: () => Navigator.pop(context),
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  visualDensity: buttonsVisualDensity,
                  icon: const Icon(Icons.close),
                ),
                IconButton.filled(
                  onPressed: download,
                  tooltip: 'Download',
                  visualDensity: buttonsVisualDensity,
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
