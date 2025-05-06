import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'leaderboard_screen.dart';

// Lớp dữ liệu để quản lý thẻ bài
class CardData {
  String image;
  bool isFlipped;
  bool isMatched;

  CardData({
    required this.image,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

class GameScreen extends StatefulWidget {
  final int gridSize;
  final String playerName;
  const GameScreen(
      {super.key, required this.gridSize, required this.playerName});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<CardData> _cards = [];
  int? _firstFlippedIndex;
  int _moveCount = 0;
  bool _isProcessing = false; // Biến để kiểm soát trạng thái xử lý

  @override
  void initState() {
    super.initState();
    _initializeCards();
  }

  void _initializeCards() {
    final pairCount = (widget.gridSize * widget.gridSize) ~/ 2;
    final images = List.generate(
      pairCount,
      (index) => 'assets/images/card${index + 1}.png',
    );

    _cards = [];
    for (var image in images) {
      _cards.add(CardData(image: image));
      _cards.add(CardData(image: image));
    }
    _cards.shuffle();
  }

  void _flipCard(int index) {
    // Không cho phép lật thẻ nếu đang xử lý hoặc thẻ đã lật/đã khớp
    if (_isProcessing || _cards[index].isFlipped || _cards[index].isMatched)
      return;

    setState(() {
      _cards[index].isFlipped = true;
      _moveCount++;
    });

    if (_firstFlippedIndex == null) {
      _firstFlippedIndex = index;
    } else {
      if (_cards[_firstFlippedIndex!].image == _cards[index].image) {
        setState(() {
          _cards[_firstFlippedIndex!].isMatched = true;
          _cards[index].isMatched = true;
          _firstFlippedIndex = null;
        });
        _checkWin();
      } else {
        setState(() {
          _isProcessing = true; // Đặt trạng thái đang xử lý
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _cards[_firstFlippedIndex!].isFlipped = false;
              _cards[index].isFlipped = false;
              _firstFlippedIndex = null;
              _isProcessing = false; // Kết thúc trạng thái xử lý
            });
          }
        });
      }
    }
  }

  Future<void> _saveScore() async {
    final prefs = await SharedPreferences.getInstance();
    final leaderboard = prefs.getStringList('leaderboard') ?? [];
    leaderboard.add('${widget.playerName}|${widget.gridSize}|$_moveCount');
    await prefs.setStringList('leaderboard', leaderboard);
  }

  void _checkWin() {
    if (_cards.every((card) => card.isMatched)) {
      _saveScore();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Congratulations!'),
          content: Text('You won in $_moveCount moves!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Back to Menu'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
                );
              },
              child: const Text('View Leaderboard'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text('Memory Game'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Lượt: $_moveCount',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: widget.gridSize * 100.0,
            maxHeight: widget.gridSize * 100.0,
          ),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: GridView.builder(
              padding: const EdgeInsets.all(20.0),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.gridSize,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 1.0,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _flipCard(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _cards[index].isMatched
                          ? Colors.green
                          : const Color(0xFF0288D1),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: _cards[index].isFlipped || _cards[index].isMatched
                        ? Image.asset(
                            _cards[index].image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text(
                                  'Card ${index ~/ 2 + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              '?',
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
