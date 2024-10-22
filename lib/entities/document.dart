class Document {
  const Document({
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
