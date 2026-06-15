class Vehicle {
  final String id;
  final String make;
  final String model;
  final String variant;
  final int year;
  final int engineCapacityCC;
  final String fuelType;
  final double tankCapacityL;
  final double ratedConsumptionL100km;
  final bool isActive;
  final String? imagePath;

  const Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.variant,
    required this.year,
    required this.engineCapacityCC,
    required this.fuelType,
    required this.tankCapacityL,
    required this.ratedConsumptionL100km,
    required this.isActive,
    this.imagePath,
  });

  String get displayName => '$year $make $model $variant';

  Vehicle copyWith({
    String? id,
    String? make,
    String? model,
    String? variant,
    int? year,
    int? engineCapacityCC,
    String? fuelType,
    double? tankCapacityL,
    double? ratedConsumptionL100km,
    bool? isActive,
    String? imagePath,
  }) {
    return Vehicle(
      id: id ?? this.id,
      make: make ?? this.make,
      model: model ?? this.model,
      variant: variant ?? this.variant,
      year: year ?? this.year,
      engineCapacityCC: engineCapacityCC ?? this.engineCapacityCC,
      fuelType: fuelType ?? this.fuelType,
      tankCapacityL: tankCapacityL ?? this.tankCapacityL,
      ratedConsumptionL100km:
          ratedConsumptionL100km ?? this.ratedConsumptionL100km,
      isActive: isActive ?? this.isActive,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'variant': variant,
      'year': year,
      'engineCapacityCC': engineCapacityCC,
      'fuelType': fuelType,
      'tankCapacityL': tankCapacityL,
      'ratedConsumptionL100km': ratedConsumptionL100km,
      'isActive': isActive,
      'imagePath': imagePath,
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'] as String,
      make: map['make'] as String,
      model: map['model'] as String,
      variant: map['variant'] as String,
      year: map['year'] as int,
      engineCapacityCC: map['engineCapacityCC'] as int,
      fuelType: map['fuelType'] as String,
      tankCapacityL: (map['tankCapacityL'] as num).toDouble(),
      ratedConsumptionL100km:
          (map['ratedConsumptionL100km'] as num).toDouble(),
      isActive: map['isActive'] as bool,
      imagePath: map['imagePath'] as String?,
    );
  }
}
