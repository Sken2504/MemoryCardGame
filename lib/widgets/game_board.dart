import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../utils/game_logic.dart';
import 'card_widget.dart';

class GameBoard extends StatefulWidget {
  final int gridSize;

  const GameBoard({super.key, required this.gridSize});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late List<CardModel> cards;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    cards = generateShuffledCards(widget.gridSize);
  }

  void _onCardTapped(int index) async {
    if (isProcessing) return;
    isProcessing = true;

    final gameWon = await handleCardFlip(cards, index, () => setState(() {}));
    if (gameWon) {
      _showWinDialog();
    }

    isProcessing = false;
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('You Win!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    cards = generateShuffledCards(widget.gridSize);
                  });
                },
                child: const Text('Play Again'),
              ),
              TextButton(
                onPressed:
                    () => Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text('Back to Menu'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.gridSize,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: cards.length,
      itemBuilder:
          (context, index) =>
              CardWidget(card: cards[index], onTap: () => _onCardTapped(index)),
    );
  }
}
