class CarbonRecord {
  final String id;
  final String vehicleId;
  final DateTime month;
  final double totalLitres;

  const CarbonRecord({
    required this.id,
    required this.vehicleId,
    required this.month,
    required this.totalLitres,
  });

  double get co2Kg => totalLitres * 2.31;

  double get treesNeededToOffset => co2Kg / 21.77;

  CarbonRecord copyWith({
    String? id,
    String? vehicleId,
    DateTime? month,
    double? totalLitres,
  }) {
    return CarbonRecord(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      month: month ?? this.month,
      totalLitres: totalLitres ?? this.totalLitres,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'month': month.millisecondsSinceEpoch,
      'totalLitres': totalLitres,
    };
  }

  factory CarbonRecord.fromMap(Map<String, dynamic> map) {
    return CarbonRecord(
      id: map['id'] as String,
      vehicleId: map['vehicleId'] as String,
      month: DateTime.fromMillisecondsSinceEpoch(map['month'] as int),
      totalLitres: (map['totalLitres'] as num).toDouble(),
    );
  }
}
