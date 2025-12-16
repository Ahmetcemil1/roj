import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String _boxName = 'user_data';
  
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  static Box get _box => Hive.box(_boxName);

  // XP (Puan)
  static int get xp => _box.get('xp', defaultValue: 0);
  static Future<void> addXp(int amount) async {
    int current = xp;
    await _box.put('xp', current + amount);
  }

  // Can (Hearts)
  static int get hearts => _box.get('hearts', defaultValue: 5);
  static Future<void> decreaseHeart() async {
    int current = hearts;
    if (current > 0) await _box.put('hearts', current - 1);
  }
  static Future<void> refillHearts() async => await _box.put('hearts', 5);

  // Seviye Kilidi (Level Locking)
  static int get completedLevel => _box.get('completedLevel', defaultValue: 1);
  static Future<void> unlockNextLevel(int currentLevelId) async {
    if (currentLevelId >= completedLevel) {
      await _box.put('completedLevel', currentLevelId + 1);
    }
  }

  // Seri (Streak)
  static int get streak => _box.get('streak', defaultValue: 0);
  
  // İlk çalıştırma kontrolü
  static bool get isFirstLaunch => _box.get('isFirstLaunch', defaultValue: true);
  static Future<void> setFirstLaunchDone() async => await _box.put('isFirstLaunch', false);
}
