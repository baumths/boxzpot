class Box {
  const Box({
    required this.id,
    required this.hash,
    required this.code,
    required this.name,
    required this.description,
  });

  final int id;
  final String hash;
  final String code;
  final String name;
  final String description;
}

class BoxItem {
  const BoxItem({
    required this.id,
    required this.boxId,
    required this.code,
    required this.title,
    required this.date,
    required this.accessPoints,
  });

  final int id;
  final int boxId;
  final String code;
  final String title;
  final String date;
  final String accessPoints;
}
