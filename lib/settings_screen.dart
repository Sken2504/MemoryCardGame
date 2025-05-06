import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _musicEnabled = true;
  double _musicVolume = 0.5;
  double _sfxVolume = 0.5;
  String _selectedMusic = 'Bossa Antigua.mp3';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _musicEnabled = prefs.getBool('musicEnabled') ?? true;
      _musicVolume = prefs.getDouble('musicVolume') ?? 0.5;
      _sfxVolume = prefs.getDouble('sfxVolume') ?? 0.5;
      _selectedMusic = prefs.getString('selectedMusic') ?? 'Bossa Antigua.mp3';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('musicEnabled', _musicEnabled);
    await prefs.setDouble('musicVolume', _musicVolume);
    await prefs.setDouble('sfxVolume', _sfxVolume);
    await prefs.setString('selectedMusic', _selectedMusic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Âm thanh',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Bật nhạc nền', style: TextStyle(fontSize: 16)),
                Switch(
                  value: _musicEnabled,
                  onChanged: (value) {
                    setState(() {
                      _musicEnabled = value;
                    });
                    _saveSettings();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Chọn nhạc nền', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: _selectedMusic,
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                  value: 'Bossa Antigua.mp3',
                  child: Text('Bossa Antigua'),
                ),
                DropdownMenuItem(
                  value: 'Daily Beetle.mp3',
                  child: Text('Daily Beetle'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedMusic = value;
                  });
                  _saveSettings();
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Âm lượng nhạc nền', style: TextStyle(fontSize: 16)),
                Text('${(_musicVolume * 100).toInt()}%'),
              ],
            ),
            Slider(
              value: _musicVolume,
              min: 0.0,
              max: 1.0,
              onChanged: (value) {
                setState(() {
                  _musicVolume = value;
                });
                _saveSettings();
              },
            ),
            // Bỏ phần âm lượng hiệu ứng vì không dùng hiệu ứng âm thanh
          ],
        ),
      ),
    );
  }
}
