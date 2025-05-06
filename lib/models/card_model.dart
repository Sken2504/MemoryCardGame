class CardModel {
  final int id;
  final String imagePath;
  bool isFlipped;
  bool isMatched;

  CardModel({
    required this.id,
    required this.imagePath,
    this.isFlipped = false,
    this.isMatched = false,
  });
}
