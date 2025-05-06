import 'dart:math';
import 'package:flutter/material.dart'; // Thêm dòng này
import '../models/card_model.dart';
import '../data/mock_data.dart';

List<CardModel> generateShuffledCards(int size) {
  final count = (size * size) ~/ 2; // Số cặp thẻ
  final baseImages = <String>[];

  // Tái sử dụng ảnh từ mockImagePaths
  for (int i = 0; i < count; i++) {
    baseImages.add(mockImagePaths[i % mockImagePaths.length]);
  }

  final cards = <CardModel>[];
  for (int i = 0; i < count; i++) {
    cards.add(CardModel(id: i * 2, imagePath: baseImages[i]));
    cards.add(CardModel(id: i * 2 + 1, imagePath: baseImages[i]));
  }

  cards.shuffle(Random());
  return cards;
}

CardModel? firstCard;

Future<bool> handleCardFlip(
  List<CardModel> cards,
  int index,
  VoidCallback refresh, // VoidCallback giờ sẽ hoạt động
) async {
  cards[index].isFlipped = true;
  refresh();

  if (firstCard == null) {
    firstCard = cards[index];
    return false;
  } else {
    if (firstCard!.imagePath == cards[index].imagePath &&
        firstCard!.id != cards[index].id) {
      cards[index].isMatched = true;
      firstCard!.isMatched = true;
    } else {
      await Future.delayed(const Duration(seconds: 1));
      cards[index].isFlipped = false;
      firstCard!.isFlipped = false;
    }
    firstCard = null;
    refresh();
    return cards.every((c) => c.isMatched);
  }
}
