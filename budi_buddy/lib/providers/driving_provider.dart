import 'package:flutter/material.dart';

import '../core/mock_data.dart';
import '../models/trip_record.dart';

class DrivingProvider extends ChangeNotifier {
  final List<TripRecord> _trips = List<TripRecord>.from(MockData.tripRecords);

  List<TripRecord> get allTrips => List.unmodifiable(_trips);

  int get overallEfficiencyScore => MockData.overallEfficiencyScore;

  String get efficiencyGrade => MockData.efficiencyGrade;

  String get efficiencyFeedback => MockData.efficiencyFeedback;

  List<Map<String, String>> get drivingTips => MockData.drivingTips;

  List<TripRecord> tripsForVehicle(String vehicleId) {
    final trips = _trips.where((t) => t.vehicleId == vehicleId).toList();
    trips.sort((a, b) => b.date.compareTo(a.date));
    return trips;
  }

  TripRecord? tripById(String id) {
    for (final trip in _trips) {
      if (trip.id == id) return trip;
    }
    return null;
  }

  double averageEfficiencyScore(String vehicleId) {
    final trips = tripsForVehicle(vehicleId);
    if (trips.isEmpty) return 0.0;
    final total = trips.fold<int>(0, (sum, t) => sum + t.efficiencyScore);
    return total / trips.length;
  }

  double totalDistanceForVehicle(String vehicleId) {
    final trips = tripsForVehicle(vehicleId);
    return trips.fold(0.0, (sum, t) => sum + t.distanceKm);
  }
}
