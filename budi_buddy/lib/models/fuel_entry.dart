class FuelEntry {
  final String id;
  final String vehicleId;
  final DateTime date;
  final String fuelType;
  final double litres;
  final double pricePerLitre;
  final double odometerKm;
  final String stationName;
  final String? notes;

  const FuelEntry({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.fuelType,
    required this.litres,
    required this.pricePerLitre,
    required this.odometerKm,
    required this.stationName,
    this.notes,
  });

  double get totalCost => litres * pricePerLitre;

  FuelEntry copyWith({
    String? id,
    String? vehicleId,
    DateTime? date,
    String? fuelType,
    double? litres,
    double? pricePerLitre,
    double? odometerKm,
    String? stationName,
    String? notes,
  }) {
    return FuelEntry(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      date: date ?? this.date,
      fuelType: fuelType ?? this.fuelType,
      litres: litres ?? this.litres,
      pricePerLitre: pricePerLitre ?? this.pricePerLitre,
      odometerKm: odometerKm ?? this.odometerKm,
      stationName: stationName ?? this.stationName,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'date': date.millisecondsSinceEpoch,
      'fuelType': fuelType,
      'litres': litres,
      'pricePerLitre': pricePerLitre,
      'odometerKm': odometerKm,
      'stationName': stationName,
      'notes': notes,
    };
  }

  factory FuelEntry.fromMap(Map<String, dynamic> map) {
    return FuelEntry(
      id: map['id'] as String,
      vehicleId: map['vehicleId'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      fuelType: map['fuelType'] as String,
      litres: (map['litres'] as num).toDouble(),
      pricePerLitre: (map['pricePerLitre'] as num).toDouble(),
      odometerKm: (map['odometerKm'] as num).toDouble(),
      stationName: map['stationName'] as String,
      notes: map['notes'] as String?,
    );
  }
}
