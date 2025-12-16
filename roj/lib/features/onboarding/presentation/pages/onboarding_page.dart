import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../main_wrapper_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  void _finishOnboarding(BuildContext context, {required bool unlockedMode}) async {
    // İlk açılışı tamamlandı olarak işaretle
    await StorageService.setFirstLaunchDone();
    
    // Eğer tecrübelyse ilk 3 seviyeyi aç
    if (unlockedMode) {
      await StorageService.unlockNextLevel(1);
      await StorageService.unlockNextLevel(2);
      await StorageService.unlockNextLevel(3);
    }

    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainWrapperPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // İkon ve Başlık
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.wb_sunny_rounded, size: 80, color: AppColors.primary),
              ),
              const SizedBox(height: 32),
              const Text(
                "Roj'a Hoş Geldiniz",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Kürtçe öğrenmenin en renkli ve keyifli yolu.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              
              // Seçenekler
              const Text(
                "Kürtçe biliyor musunuz?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: () => _finishOnboarding(context, unlockedMode: false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.all(20),
                ),
                child: const Text("Hayır, Sıfırdan Başlıyorum"),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => _finishOnboarding(context, unlockedMode: true),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  side: const BorderSide(color: AppColors.secondary, width: 2),
                ),
                child: const Text(
                  "Evet, Biraz Biliyorum",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondary),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
