import 'package:flutter/material.dart';

import '../core/mock_data.dart';
import '../models/vehicle.dart';

class VehicleProvider extends ChangeNotifier {
  List<Vehicle> _vehicles = List<Vehicle>.from(MockData.vehicles);
  bool _isLoading = false;

  List<Vehicle> get vehicles => List.unmodifiable(_vehicles);

  Vehicle? get activeVehicle {
    if (_vehicles.isEmpty) return null;
    return _vehicles.firstWhere(
      (v) => v.isActive,
      orElse: () => _vehicles.first,
    );
  }

  bool get isLoading => _isLoading;

  Future<void> addVehicle(Vehicle vehicle) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    _vehicles.add(vehicle.copyWith(id: id));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteVehicle(String id) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 400));

    final removingActive = _vehicles.any((v) => v.id == id && v.isActive);
    _vehicles.removeWhere((v) => v.id == id);

    if (removingActive && _vehicles.isNotEmpty) {
      final first = _vehicles.first;
      _vehicles[0] = first.copyWith(isActive: true);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setActiveVehicle(String id) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    _vehicles = _vehicles
        .map((v) => v.copyWith(isActive: v.id == id))
        .toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateVehicle(Vehicle updatedVehicle) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    final index = _vehicles.indexWhere((v) => v.id == updatedVehicle.id);
    if (index != -1) {
      _vehicles[index] = updatedVehicle;
    }

    _isLoading = false;
    notifyListeners();
  }
}
