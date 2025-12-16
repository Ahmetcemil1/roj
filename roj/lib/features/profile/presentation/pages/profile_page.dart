import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/storage_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        actions: [
          IconButton(onIcon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('user_data').listenable(),
        builder: (context, box, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text("Kullanıcı", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const Text("Hêvîdar (Umutlu)", style: TextStyle(color: Colors.grey)),
                
                const SizedBox(height: 32),
                
                // İstatistikler (Gerçek Veri)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem("Toplam Puan", "${StorageService.xp}", Icons.shield),
                    _buildStatItem("Günlük Seri", "${StorageService.streak}", Icons.local_fire_department),
                    _buildStatItem("Seviye", "${StorageService.completedLevel}", Icons.emoji_events),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Ayarlar Listesi
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text("Dil Ayarları"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text("Bildirimler"),
                  trailing: Switch(value: true, onChanged: (v) {}),
                ),
                 ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text("Uygulamayı Paylaş"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                // Debug Butonu (Verileri Sıfırla)
                ListTile(
                   leading: const Icon(Icons.delete_forever, color: Colors.red),
                   title: const Text("İlerlemeyi Sıfırla (Debug)", style: TextStyle(color: Colors.red)),
                   onTap: () {
                      Hive.box('user_data').clear();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Veriler silindi.")));
                   },
                )
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.secondary, size: 30),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
