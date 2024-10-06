import 'package:flutter/material.dart';

import '../../entities/box.dart';

class BoxDetails extends StatelessWidget {
  const BoxDetails({super.key, required this.box});

  final Box box;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Box'),
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
              Text('${box.code} - ${box.name}'),
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



      ),
    );
  }
}
