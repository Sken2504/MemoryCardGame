import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gamescreen.dart';
import 'leaderboard_screen.dart';
import 'guide_screen.dart';
import 'settings_screen.dart'; // Import màn hình Cài đặt

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Card Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ModeSelectionScreen(),
    );
  }
}

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  void _showNameDialog(BuildContext context, int gridSize) {
    final TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Your Name'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Your name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GameScreen(
                      gridSize: gridSize,
                      playerName: nameController.text.trim(),
                    ),
                  ),
                );
              }
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Game Mode')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showNameDialog(context, 4),
              child: const Text('4x4 Mode'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showNameDialog(context, 6),
              child: const Text('6x6 Mode'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showNameDialog(context, 8),
              child: const Text('8x8 Mode'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LeaderboardScreen(),
                ),
              ),
              child: const Text('View Leaderboard'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GuideScreen(),
                ),
              ),
              child: const Text('Hướng dẫn chơi'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              ),
              child: const Text('Cài đặt'),
            ),
          ],
        ),
      ),
    );
  }
}
