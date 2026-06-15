class UserProfile {
  final String id;
  final String name;
  final String email;
  final String preferredFuelType;
  final double monthlyBudget;
  final String avatarInitials;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.preferredFuelType,
    required this.monthlyBudget,
    required this.avatarInitials,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? preferredFuelType,
    double? monthlyBudget,
    String? avatarInitials,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      preferredFuelType: preferredFuelType ?? this.preferredFuelType,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      avatarInitials: avatarInitials ?? this.avatarInitials,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'preferredFuelType': preferredFuelType,
      'monthlyBudget': monthlyBudget,
      'avatarInitials': avatarInitials,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      preferredFuelType: map['preferredFuelType'] as String,
      monthlyBudget: (map['monthlyBudget'] as num).toDouble(),
      avatarInitials: map['avatarInitials'] as String,
    );
  }
}
