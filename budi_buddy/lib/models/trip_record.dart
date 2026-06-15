class TripRecord {
  final String id;
  final String vehicleId;
  final DateTime date;
  final double distanceKm;
  final int durationMinutes;
  final double fuelUsedL;
  final int efficiencyScore;
  final double avgSpeedKmh;
  final int accelerationScore;
  final int brakingScore;
  final int speedConsistencyScore;
  final String feedbackMessage;

  const TripRecord({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.distanceKm,
    required this.durationMinutes,
    required this.fuelUsedL,
    required this.efficiencyScore,
    required this.avgSpeedKmh,
    required this.accelerationScore,
    required this.brakingScore,
    required this.speedConsistencyScore,
    required this.feedbackMessage,
  });

  TripRecord copyWith({
    String? id,
    String? vehicleId,
    DateTime? date,
    double? distanceKm,
    int? durationMinutes,
    double? fuelUsedL,
    int? efficiencyScore,
    double? avgSpeedKmh,
    int? accelerationScore,
    int? brakingScore,
    int? speedConsistencyScore,
    String? feedbackMessage,
  }) {
    return TripRecord(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      date: date ?? this.date,
      distanceKm: distanceKm ?? this.distanceKm,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      fuelUsedL: fuelUsedL ?? this.fuelUsedL,
      efficiencyScore: efficiencyScore ?? this.efficiencyScore,
      avgSpeedKmh: avgSpeedKmh ?? this.avgSpeedKmh,
      accelerationScore: accelerationScore ?? this.accelerationScore,
      brakingScore: brakingScore ?? this.brakingScore,
      speedConsistencyScore:
          speedConsistencyScore ?? this.speedConsistencyScore,
      feedbackMessage: feedbackMessage ?? this.feedbackMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'date': date.millisecondsSinceEpoch,
      'distanceKm': distanceKm,
      'durationMinutes': durationMinutes,
      'fuelUsedL': fuelUsedL,
      'efficiencyScore': efficiencyScore,
      'avgSpeedKmh': avgSpeedKmh,
      'accelerationScore': accelerationScore,
      'brakingScore': brakingScore,
      'speedConsistencyScore': speedConsistencyScore,
      'feedbackMessage': feedbackMessage,
    };
  }

  factory TripRecord.fromMap(Map<String, dynamic> map) {
    return TripRecord(
      id: map['id'] as String,
      vehicleId: map['vehicleId'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      distanceKm: (map['distanceKm'] as num).toDouble(),
      durationMinutes: map['durationMinutes'] as int,
      fuelUsedL: (map['fuelUsedL'] as num).toDouble(),
      efficiencyScore: map['efficiencyScore'] as int,
      avgSpeedKmh: (map['avgSpeedKmh'] as num).toDouble(),
      accelerationScore: map['accelerationScore'] as int,
      brakingScore: map['brakingScore'] as int,
      speedConsistencyScore: map['speedConsistencyScore'] as int,
      feedbackMessage: map['feedbackMessage'] as String,
    );
  }
}
