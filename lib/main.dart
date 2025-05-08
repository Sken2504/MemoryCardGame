import 'package:flutter/material.dart';
import 'gamescreen.dart';
import 'leaderboard_screen.dart';
import 'guide_screen.dart';
import 'settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Card Game',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(220, 56),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      home: const ModeSelectionScreen(),
    );
  }
}

class ModeSelectionScreen extends StatefulWidget {
  const ModeSelectionScreen({super.key});

  @override
  _ModeSelectionScreenState createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _showNameDialog(BuildContext context, int gridSize) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF0288D1), // Nền dialog màu xanh
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: const BorderSide(
                color: Colors.black,
                width: 3.0,
              ), // Viền đen quanh dialog
            ),
            title: const Text(
              'Nhập Tên Của Bạn',
              style: TextStyle(color: Colors.white), // Chữ tiêu đề trắng
            ),
            content: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ), // Khung đen quanh TextField
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white, // Nền TextField màu trắng
              ),
              child: TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.black), // Chữ nhập màu đen
                decoration: const InputDecoration(
                  hintText: 'Tên của bạn',
                  hintStyle: TextStyle(
                    color: Colors.black, // Chữ gợi ý màu đen
                  ),
                  filled: true,
                  fillColor: Colors.white, // Đảm bảo nền trắng
                  border: InputBorder.none, // Xóa viền mặc định của TextField
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ), // Padding bên trong
                ),
                autofocus: true,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Hủy',
                  style: TextStyle(color: Colors.white), // Chữ Hủy trắng
                ),
              ),
              TextButton(
                onPressed: () {
                  final playerName = _nameController.text.trim();
                  if (playerName.isNotEmpty) {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => GameScreen(
                              gridSize: gridSize,
                              playerName: playerName,
                            ),
                      ),
                    ).then((_) {
                      _nameController.clear();
                    });
                  }
                },
                child: const Text(
                  'Bắt đầu',
                  style: TextStyle(color: Colors.white), // Chữ Bắt đầu trắng
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ElevatedButton(
          onPressed: () {
            print('Button pressed: $label');
            onPressed();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0288D1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(label),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
          color: Colors.black.withOpacity(0.3),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Memory Card Game',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildButton(
                    label: 'Chế Độ 4x4',
                    onPressed: () => _showNameDialog(context, 4),
                  ),
                  _buildButton(
                    label: 'Chế Độ 6x6',
                    onPressed: () => _showNameDialog(context, 6),
                  ),
                  _buildButton(
                    label: 'Chế Độ 8x8',
                    onPressed: () => _showNameDialog(context, 8),
                  ),
                  _buildButton(
                    label: 'Bảng Xếp Hạng',
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LeaderboardScreen(),
                          ),
                        ),
                  ),
                  _buildButton(
                    label: 'Hướng Dẫn',
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const GuideScreen(),
                          ),
                        ),
                  ),
                  _buildButton(
                    label: 'Cài Đặt',
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
