import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../../entities/box.dart';
import '../../shared/box_title.dart';

class BoxDetails extends StatelessWidget {
  const BoxDetails({super.key, required this.box});

  final Box box;

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
              builder: (_) => Dialog(child: BoxQrCodeView(box: box)),
            ),
            icon: const Icon(Icons.qr_code),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BoxInfoCard(box: box),
          ],
        ),
      ),
    );
  }
}

class BoxInfoCard extends StatelessWidget {
  const BoxInfoCard({super.key, required this.box});

  final Box box;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BoxTitle(box: box),
              if (box.description.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(box.description),
              ],
            ],
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
