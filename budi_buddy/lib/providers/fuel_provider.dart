import 'package:flutter/material.dart';

import '../core/local_storage.dart';
import '../core/mock_data.dart';
import '../models/fuel_entry.dart';

class FuelProvider extends ChangeNotifier {
  static const String _storageKey = 'fuel_entries';

  List<FuelEntry> _entries = [];
  bool _isLoading = false;

  FuelProvider() {
    _loadEntries();
  }

  void _loadEntries() {
    final stored = LocalStorage.getList(_storageKey);
    if (stored != null) {
      _entries = stored.map(FuelEntry.fromMap).toList();
    } else {
      _entries = List<FuelEntry>.from(MockData.fuelEntries);
      _persist();
    }
  }

  void _persist() {
    LocalStorage.saveList(
      _storageKey,
      _entries.map((e) => e.toMap()).toList(),
    );
  }

  List<FuelEntry> get allEntries => List.unmodifiable(_entries);

  bool get isLoading => _isLoading;

  List<FuelEntry> entriesForVehicle(String vehicleId) {
    final entries = _entries.where((e) => e.vehicleId == vehicleId).toList();
    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  FuelEntry? latestEntryForVehicle(String vehicleId) {
    final entries = entriesForVehicle(vehicleId);
    if (entries.isEmpty) return null;
    return entries.first;
  }

  FuelEntry? previousEntryForVehicle(String vehicleId, String currentEntryId) {
    final entries = entriesForVehicle(vehicleId);
    final index = entries.indexWhere((e) => e.id == currentEntryId);
    if (index == -1 || index + 1 >= entries.length) return null;
    return entries[index + 1];
  }

  double computeDistanceSinceLastFill(FuelEntry current, FuelEntry? previous) {
    if (previous == null) return 0.0;
    final distance = current.odometerKm - previous.odometerKm;
    if (distance <= 0) return 0.0;
    return distance;
  }

  double computeFuelEconomy(FuelEntry current, FuelEntry? previous) {
    final distance = computeDistanceSinceLastFill(current, previous);
    if (distance == 0 || current.litres == 0) return 0.0;
    return double.parse((distance / current.litres).toStringAsFixed(1));
  }

  double computeCostPerKm(FuelEntry current, FuelEntry? previous) {
    final distance = computeDistanceSinceLastFill(current, previous);
    if (distance == 0) return 0.0;
    return double.parse((current.totalCost / distance).toStringAsFixed(3));
  }

  Future<void> addEntry(FuelEntry entry) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final id = 'fe_${DateTime.now().millisecondsSinceEpoch}';
    _entries.add(entry.copyWith(id: id));
    _entries.sort((a, b) => b.date.compareTo(a.date));
    _persist();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteEntry(String id) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 400));

    _entries.removeWhere((e) => e.id == id);
    _persist();

    _isLoading = false;
    notifyListeners();
  }

  double totalSpendingForVehicle(String vehicleId, {DateTime? from, DateTime? to}) {
    final entries = _entries.where((e) {
      if (e.vehicleId != vehicleId) return false;
      if (from != null && e.date.isBefore(from)) return false;
      if (to != null && e.date.isAfter(to)) return false;
      return true;
    });
    return entries.fold(0.0, (sum, e) => sum + e.totalCost);
  }

  double averageFuelEconomyForVehicle(String vehicleId) {
    final entries = entriesForVehicle(vehicleId);
    final economies = <double>[];
    for (var i = 0; i < entries.length - 1; i++) {
      final economy = computeFuelEconomy(entries[i], entries[i + 1]);
      if (economy > 0) economies.add(economy);
    }
    if (economies.isEmpty) return 0.0;
    final average = economies.reduce((a, b) => a + b) / economies.length;
    return double.parse(average.toStringAsFixed(1));
  }
}
