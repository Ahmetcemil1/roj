import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../lesson/presentation/pages/lesson_page.dart';
import '../../ai_chat/presentation/pages/heval_page.dart';
import '../../../../core/services/storage_service.dart';
import '../widgets/daily_proverb_widget.dart';

class LevelNode {
  final int id;
  final String title;
  final IconData icon;
  final bool isLocked;
  final int stars; // 0-3

  LevelNode({
    required this.id,
    required this.title,
    required this.icon,
    this.isLocked = true,
    this.stars = 0,
  });
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Örnek Veri
    final List<LevelNode> levels = [
      LevelNode(id: 1, title: "Bingeh 1\n(Temeller)", icon: Icons.home_filled, isLocked: false, stars: 2),
      LevelNode(id: 2, title: "Silav\n(Selam)", icon: Icons.waving_hand, isLocked: false, stars: 1),
      LevelNode(id: 3, title: "Ziman\n(Dil)", icon: Icons.translate, isLocked: true),
      LevelNode(id: 4, title: "Xwarin\n(Yemek)", icon: Icons.restaurant, isLocked: true),
      LevelNode(id: 5, title: "Malbat\n(Aile)", icon: Icons.family_restroom, isLocked: true),
      LevelNode(id: 6, title: "Reng\n(Renkler)", icon: Icons.palette, isLocked: true),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      // AppBar removed to put in body for reactive updates
      body: ValueListenableBuilder(
        valueListenable: Hive.box('user_data').listenable(),
        builder: (context, box, widget) {
          final int currentXP = StorageService.xp;
          final int currentHearts = StorageService.hearts;
          final int streak = StorageService.streak;
          final int maxUnlocked = StorageService.completedLevel;

          // Dinamik Seviye Verisi
          final List<LevelNode> realLevels = levels.map((l) {
            bool isLocked = l.id > maxUnlocked; // Eğer seviye ID'si açılan max seviyeden büyükse kilitli
            // İlk seviye her zaman açık (mantık hatası varsa düzelt)
            if (l.id == 1) isLocked = false; 
            
            return LevelNode(
              id: l.id,
              title: l.title,
              icon: l.icon,
              isLocked: isLocked,
              stars: isLocked ? 0 : 2, // Yıldız mantığı da eklenebilir
            );
          }).toList();

          return Column(
            children: [
               // AppBar yerine custom header kullanarak ValueListenableBuilder icinde guncellenmesini sagliyoruz
               // Veya AppBar'i da sarmalayabiliriz ama body icinde yapmak daha kolay.
               _buildHeader(currentXP, currentHearts, streak),
               
               // Günün Sözü Widget'ı
               const DailyProverbWidget(),

               Expanded(
                 child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100, top: 20),
                    itemCount: realLevels.length,
                    itemBuilder: (context, index) {
                      final level = realLevels[index];
                      final double horizontalOffset = (index % 2 == 0) ? -50.0 : 50.0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Transform.translate(
                          offset: Offset(horizontalOffset, 0),
                          child: Center(child: _buildLevelNode(context, level)),
                        ),
                      );
                    },
                 ),
               ),
            ],
          );
        }
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
            // AI Asistanı Aç
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HevalPage()));
        },
        backgroundColor: AppColors.secondary,
        icon: const Icon(Icons.smart_toy),
        label: const Text("Heval (AI)"),
      ),
    );
  }

  Widget _buildHeader(int xp, int hearts, int streak) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: SafeArea( // StatusBar altinda kalsin
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               const Icon(Icons.flag, color: AppColors.primary),
               Row(
                 children: [
                   const Icon(Icons.local_fire_department, color: Colors.orange),
                   Text(" $streak", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                 ],
               ),
               Row(
                 children: [
                   const Icon(Icons.favorite, color: Colors.red),
                   Text(" $hearts", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                   const SizedBox(width: 12),
                   const Icon(Icons.diamond, color: Colors.blue),
                   Text(" $xp", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                 ],
               ),
            ],
          ),
      ),
    );
  }

  Widget _buildLevelNode(BuildContext context, LevelNode level) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Arka plan gölgesi (3D efekti için)
            Container(
              width: 80,
              height: 80,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: level.isLocked ? Colors.grey.shade400 : AppColors.primary.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
            // Ana Düğme
            InkWell(
              onTap: level.isLocked ? null : () {
                // Ders sayfasına git
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => LessonPage(lessonId: level.id)),
                );
              },
              borderRadius: BorderRadius.circular(40),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: level.isLocked ? Colors.grey.shade300 : AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                ),
                child: Icon(
                  level.isLocked ? Icons.lock : level.icon,
                  size: 40,
                  color: level.isLocked ? Colors.grey.shade500 : Colors.white,
                ),
              ),
            ),
            // Yıldızlar (Eğer tamamlandıysa)
             if (!level.isLocked && level.stars > 0)
              Positioned(
                bottom: 0,
                right: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(level.stars, (index) => const Icon(Icons.star, size: 16, color: Colors.yellow)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          level.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: level.isLocked ? Colors.grey : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
