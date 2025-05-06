import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'leaderboard_screen.dart';

// Lớp dữ liệu để quản lý thẻ bài
class CardData {
  final String image;
  bool isFlipped;
  bool isMatched;

  CardData({
    required this.image,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

// Widget riêng để hiển thị thẻ, tối ưu render
class CardWidget extends StatelessWidget {
  final CardData card;
  final VoidCallback onTap;

  const CardWidget({
    super.key,
    required this.card,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: card.isMatched ? Colors.green : const Color(0xFF0288D1),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: card.isFlipped || card.isMatched
            ? SvgPicture.asset(
                card.image,
                fit: BoxFit.cover,
                placeholderBuilder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
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
  }
}

class GameScreen extends StatefulWidget {
  final int gridSize;
  final String playerName;

  const GameScreen({
    super.key,
    required this.gridSize,
    required this.playerName,
  });

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<CardData> _cards;
  int? _firstFlippedIndex;
  int _moveCount = 0;
  bool _isProcessing = false;

  // Danh sách file SVG thực tế
  static const List<String> _svgFiles = [
    'ad',
    'ae',
    'af',
    'ag',
    'ai',
    'al',
    'am',
    'ao',
    'aq',
    'ar',
    'as',
    'at',
    'au',
    'aw',
    'ax',
    'az',
    'ba',
    'bb',
    'bd',
    'be',
    'bf',
    'bg',
    'bh',
    'bi',
    'bj',
    'bl',
    'bm',
    'bn',
    'bo',
    'bq',
    'br',
    'bs',
    'bt',
    'bv',
    'bw',
    'by',
    'bz',
    'ca',
    'cc',
    'cd',
    'cf',
    'cg',
    'ch',
    'ci',
    'ck',
    'cl',
    'cm',
    'cn',
    'co',
    'cr',
    'cu',
    'cv',
    'cw',
    'cy',
    'cz',
    'de',
    'dj',
  ];

  @override
  void initState() {
    super.initState();
    _initializeCards();
  }

  void _initializeCards() {
    final pairCount = (widget.gridSize * widget.gridSize) ~/ 2;
    if (pairCount > _svgFiles.length) {
      throw Exception(
          'Không đủ file SVG cho số lượng thẻ yêu cầu. Cần $pairCount file, nhưng chỉ có ${_svgFiles.length} file.');
    }

    final selectedFiles = _svgFiles.take(pairCount).toList();
    final images =
        selectedFiles.map((file) => 'assets/images/$file.svg').toList();

    _cards = [];
    for (var image in images) {
      _cards.add(CardData(image: image));
      _cards.add(CardData(image: image));
    }
    _cards.shuffle();
  }

  void _flipCard(int index) {
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
          _isProcessing = true;
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _cards[_firstFlippedIndex!].isFlipped = false;
              _cards[index].isFlipped = false;
              _firstFlippedIndex = null;
              _isProcessing = false;
            });
          }
        });
      }
    }
  }

  Future<void> _saveScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final leaderboard = prefs.getStringList('leaderboard') ?? [];
      leaderboard.add('${widget.playerName}|${widget.gridSize}|$_moveCount');
      await prefs.setStringList('leaderboard', leaderboard);
    } catch (e) {
      debugPrint('Lỗi khi lưu điểm: $e');
    }
  }

  void _checkWin() {
    if (_cards.every((card) => card.isMatched)) {
      _saveScore();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Chúc mừng!'),
          content: Text('Bạn đã thắng với $_moveCount lượt!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Quay lại Menu'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
                );
              },
              child: const Text('Xem Bảng xếp hạng'),
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
        title: const Text('Trò chơi Lật thẻ'),
        centerTitle: true,
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
                return CardWidget(
                  card: _cards[index],
                  onTap: () => _flipCard(index),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
