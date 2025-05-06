import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../constants/images.dart';

class CardWidget extends StatelessWidget {
  final CardModel card;
  final VoidCallback onTap;

  const CardWidget({super.key, required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: card.isFlipped || card.isMatched ? null : onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder:
            (child, animation) =>
                ScaleTransition(scale: animation, child: child),
        child: Container(
          key: ValueKey(card.isFlipped),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: AssetImage(
                card.isFlipped || card.isMatched
                    ? card.imagePath
                    : Images.cardBack,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
