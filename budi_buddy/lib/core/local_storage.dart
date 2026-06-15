import 'package:hive_flutter/hive_flutter.dart';

/// Thin wrapper around a single Hive box that lets providers persist their
/// in-memory lists/maps as plain `Map<String, dynamic>` data (matching the
/// existing `toMap`/`fromMap` model methods) without any generated adapters.
abstract class LocalStorage {
  static const String _boxName = 'budibuddy_data';

  static late Box _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  static List<Map<String, dynamic>>? getList(String key) {
    final raw = _box.get(key);
    if (raw is! List) return null;
    return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static Future<void> saveList(String key, List<Map<String, dynamic>> value) {
    return _box.put(key, value);
  }

  static Map<String, dynamic>? getMap(String key) {
    final raw = _box.get(key);
    if (raw is! Map) return null;
    return Map<String, dynamic>.from(raw);
  }

  static Future<void> saveMap(String key, Map<String, dynamic> value) {
    return _box.put(key, value);
  }

  static bool? getBool(String key) {
    final raw = _box.get(key);
    return raw is bool ? raw : null;
  }

  static Future<void> saveBool(String key, bool value) {
    return _box.put(key, value);
  }

  static Future<void> remove(String key) {
    return _box.delete(key);
  }
}
