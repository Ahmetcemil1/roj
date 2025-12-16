import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'core/services/storage_service.dart';
import 'core/services/tts_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await TtsService.init();
  runApp(const ProviderScope(child: RojApp()));
}

class RojApp extends ConsumerWidget {
  const RojApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Roj - Kürtçe Öğren',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Sistem ayarına göre otomatik
      home: const SplashPage(),
      // TODO: Replace 'home' with 'routerConfig' when GoRouter is set up
    );
  }
}
