import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<Map<String, dynamic>> _leaderboard4x4 = [];
  List<Map<String, dynamic>> _leaderboard6x6 = [];
  List<Map<String, dynamic>> _leaderboard8x8 = [];

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    final leaderboardData = prefs.getStringList('leaderboard') ?? [];
    List<Map<String, dynamic>> allLeaderboard = leaderboardData
        .asMap()
        .entries
        .map((mapEntry) {
          final entry = mapEntry.value;
          final parts = entry.split('|');
          if (parts.length != 3) return null;
          try {
            return {
              'name': parts[0],
              'gridSize': int.parse(parts[1]),
              'moves': int.parse(parts[2]),
            };
          } catch (e) {
            return null;
          }
        })
        .where((entry) => entry != null)
        .cast<Map<String, dynamic>>()
        .toList();

    // Chia dữ liệu thành 3 danh sách theo gridSize
    setState(() {
      _leaderboard4x4 = allLeaderboard
          .where((entry) => entry['gridSize'] == 4)
          .toList()
        ..sort((a, b) => a['moves'].compareTo(b['moves']));
      _leaderboard6x6 = allLeaderboard
          .where((entry) => entry['gridSize'] == 6)
          .toList()
        ..sort((a, b) => a['moves'].compareTo(b['moves']));
      _leaderboard8x8 = allLeaderboard
          .where((entry) => entry['gridSize'] == 8)
          .toList()
        ..sort((a, b) => a['moves'].compareTo(b['moves']));
    });
  }

  Widget _buildLeaderboardSection(
      String title, List<Map<String, dynamic>> leaderboard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        leaderboard.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('No scores yet for this mode!'),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: leaderboard.length,
                itemBuilder: (context, index) {
                  final entry = leaderboard[index];
                  // Xác định màu và icon cho 3 hạng đầu
                  Color? rankColor;
                  String rankIcon = '';
                  if (index == 0) {
                    rankColor = Colors.amber; // Hạng 1: Vàng
                    rankIcon = '🥇';
                  } else if (index == 1) {
                    rankColor = Colors.grey[300]; // Hạng 2: Bạc
                    rankIcon = '🥈';
                  } else if (index == 2) {
                    rankColor = Colors.orange[300]; // Hạng 3: Đồng
                    rankIcon = '🥉';
                  }

                  return Container(
                    color: rankColor,
                    child: ListTile(
                      leading: Text(
                        '#${index + 1} $rankIcon',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              index < 3 ? FontWeight.bold : FontWeight.normal,
                          color: index < 3 ? Colors.black87 : Colors.black,
                        ),
                      ),
                      title: Text(
                        entry['name'],
                        style: TextStyle(
                          fontWeight:
                              index < 3 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(
                          'Mode: ${entry['gridSize']}x${entry['gridSize']}'),
                      trailing: Text(
                        '${entry['moves']} moves',
                        style: TextStyle(
                          fontWeight:
                              index < 3 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLeaderboardSection('4x4 Leaderboard', _leaderboard4x4),
            _buildLeaderboardSection('6x6 Leaderboard', _leaderboard6x6),
            _buildLeaderboardSection('8x8 Leaderboard', _leaderboard8x8),
          ],
        ),
      ),
    );
  }
}
