import 'package:flutter/material.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/culture/presentation/pages/dengbej_page.dart';
import '../../features/dictionary/presentation/pages/dictionary_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import 'core/constants/app_colors.dart';

class MainWrapperPage extends StatefulWidget {
  const MainWrapperPage({super.key});

  @override
  State<MainWrapperPage> createState() => _MainWrapperPageState();
}

class _MainWrapperPageState extends State<MainWrapperPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const DengbejPage(),
    const DictionaryPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        indicatorColor: AppColors.primary.withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.primary),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_music_outlined),
            selectedIcon: Icon(Icons.library_music, color: AppColors.primary),
            label: 'Kültür',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book, color: AppColors.primary),
            label: 'Sözlük',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.primary),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
