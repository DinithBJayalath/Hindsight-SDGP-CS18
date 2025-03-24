// lib/models/user_model.dart
class User {
  final String id;
  final String auth0Id;
  final String email;
  final String name;
  final String? picture;
  final bool isVerified;
  final DateTime? dateOfBirth;
  final String? country;
  final String? city;
  final String? bio;
  final bool biometricAuthentication;
  final bool cloudBackup;
  final bool pushNotifications;
  final String language;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.auth0Id,
    required this.email,
    required this.name,
    this.picture,
    required this.isVerified,
    this.dateOfBirth,
    this.country,
    this.city,
    this.bio,
    required this.biometricAuthentication,
    required this.cloudBackup,
    required this.pushNotifications,
    required this.language,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      auth0Id: json['auth0Id'],
      email: json['email'],
      name: json['name'],
      picture: json['picture'],
      isVerified: json['isVerified'] ?? false,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      country: json['country'],
      city: json['city'],
      bio: json['bio'],
      biometricAuthentication: json['biometricAuthentication'] ?? false,
      cloudBackup: json['cloudBackup'] ?? true,
      pushNotifications: json['pushNotifications'] ?? true,
      language: json['language'] ?? 'en',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'country': country,
      'city': city,
      'bio': bio,
      'biometricAuthentication': biometricAuthentication,
      'cloudBackup': cloudBackup,
      'pushNotifications': pushNotifications,
      'language': language,
    };
  }

  User copyWith({
    String? name,
    DateTime? dateOfBirth,
    String? country,
    String? city,
    String? bio,
    bool? biometricAuthentication,
    bool? cloudBackup,
    bool? pushNotifications,
    String? language,
  }) {
    return User(
      id: this.id,
      auth0Id: this.auth0Id,
      email: this.email,
      name: name ?? this.name,
      picture: this.picture,
      isVerified: this.isVerified,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      country: country ?? this.country,
      city: city ?? this.city,
      bio: bio ?? this.bio,
      biometricAuthentication:
          biometricAuthentication ?? this.biometricAuthentication,
      cloudBackup: cloudBackup ?? this.cloudBackup,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      language: language ?? this.language,
      createdAt: this.createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
