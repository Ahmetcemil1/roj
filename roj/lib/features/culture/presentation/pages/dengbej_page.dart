import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class DengbejPage extends StatelessWidget {
  const DengbejPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Örnek Dengbej Listesi
    final List<Map<String, String>> dengbejs = [
      {"name": "Şakiro", "title": "Kewê", "duration": "5:30", "image": "assets/images/sakiro.jpg"},
      {"name": "Karapetê Xaço", "title": "Zembîlfiroş", "duration": "4:15", "image": "assets/images/karapet.jpg"},
      {"name": "Ayşe Şan", "title": "Ximşê", "duration": "6:00", "image": "assets/images/ayse_san.jpg"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Dengbêj & Çand")),
      body: Column(
        children: [
          // Üst Bilgi Kartı
           Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primary.withOpacity(0.1),
            child: Row(
              children: [
                const Icon(Icons.music_note, color: AppColors.primary, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Dengbêjlerin sesinden Kürtçe'nin ahengini keşfet.",
                    style: TextStyle(color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dengbejs.length,
              itemBuilder: (context, index) {
                final item = dengbejs[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.secondary,
                      child: const Icon(Icons.mic, color: Colors.white),
                    ),
                    title: Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item['name']!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item['duration']!, style: const TextStyle(color: Colors.grey)),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.play_circle_fill, color: AppColors.primary, size: 32),
                          onPressed: () {
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Oynatılıyor...")));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
