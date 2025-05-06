import 'package:flutter/material.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hướng dẫn chơi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🧠 HƯỚNG DẪN CHƠI GAME MEMORY CARD',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '🎯 Mục tiêu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lật các cặp thẻ giống nhau để ghi điểm. Ghi nhớ vị trí của các thẻ và hoàn thành toàn bộ bảng chơi trong thời gian nhanh nhất!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '🕹️ Cách chơi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Chọn chế độ chơi:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              '4x4: Dễ – 16 thẻ (8 cặp)\n'
              '6x6: Trung bình – 36 thẻ (18 cặp)\n'
              '8x8: Khó – 64 thẻ (32 cặp)',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lật thẻ:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Nhấn vào một thẻ để lật lên.\n'
              'Nhấn tiếp một thẻ khác để tìm cặp giống nhau.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'So khớp:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Nếu hai thẻ giống nhau, chúng sẽ được giữ lại.\n'
              'Nếu khác nhau, chúng sẽ úp xuống lại sau 1–2 giây.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Chiến thắng:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Hoàn thành bảng chơi bằng cách mở hết tất cả các cặp thẻ.\n'
              'Càng ít lượt và thời gian, điểm càng cao!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '🏆 Mẹo ghi điểm cao',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ghi nhớ vị trí của thẻ sau mỗi lượt lật.\n'
              'Ưu tiên mở những thẻ bạn đã từng thấy.\n'
              'Tập trung và đừng click linh tinh!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
