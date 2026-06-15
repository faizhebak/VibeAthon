class FuelPrice {
  final String id;
  final DateTime weekStartDate;
  final double ron95;
  final double ron97;
  final double diesel;

  const FuelPrice({
    required this.id,
    required this.weekStartDate,
    required this.ron95,
    required this.ron97,
    required this.diesel,
  });

  FuelPrice copyWith({
    String? id,
    DateTime? weekStartDate,
    double? ron95,
    double? ron97,
    double? diesel,
  }) {
    return FuelPrice(
      id: id ?? this.id,
      weekStartDate: weekStartDate ?? this.weekStartDate,
      ron95: ron95 ?? this.ron95,
      ron97: ron97 ?? this.ron97,
      diesel: diesel ?? this.diesel,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weekStartDate': weekStartDate.millisecondsSinceEpoch,
      'ron95': ron95,
      'ron97': ron97,
      'diesel': diesel,
    };
  }

  factory FuelPrice.fromMap(Map<String, dynamic> map) {
    return FuelPrice(
      id: map['id'] as String,
      weekStartDate:
          DateTime.fromMillisecondsSinceEpoch(map['weekStartDate'] as int),
      ron95: (map['ron95'] as num).toDouble(),
      ron97: (map['ron97'] as num).toDouble(),
      diesel: (map['diesel'] as num).toDouble(),
    );
  }
}
