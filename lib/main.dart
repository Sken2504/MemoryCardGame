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
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(200, 50), // Kích thước nút đồng nhất
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
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

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose(); // Giải phóng TextEditingController
    super.dispose();
  }

  void _showNameDialog(BuildContext context, int gridSize) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nhập Tên Của Bạn'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: 'Tên của bạn',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              final playerName = _nameController.text.trim();
              if (playerName.isNotEmpty) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GameScreen(
                      gridSize: gridSize,
                      playerName: playerName,
                    ),
                  ),
                ).then((_) {
                  // Xóa nội dung TextField sau khi quay lại
                  _nameController.clear();
                });
              }
            },
            child: const Text('Bắt đầu'),
          ),
        ],
      ),
    );
  }

  // Widget nút tùy chỉnh để tái sử dụng
  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn Chế Độ Chơi'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                label: 'Xem Bảng Xếp Hạng',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LeaderboardScreen(),
                  ),
                ),
              ),
              _buildButton(
                label: 'Hướng Dẫn Chơi',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GuideScreen(),
                  ),
                ),
              ),
              _buildButton(
                label: 'Cài Đặt',
                onPressed: () => Navigator.push(
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
    );
  }
}
