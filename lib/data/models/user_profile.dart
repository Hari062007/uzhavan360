import 'user_role.dart';

class UserProfile {
  final String id;
  final String phoneNumber;
  final String fullName;
  final String district;
  final String taluk;
  final String village;
  final String preferredLanguage;
  final AppRole primaryRole;
  final bool isOfficialVerified;
  final bool isAdviserVerified;
  final DateTime? createdAt;

  UserProfile({
    required this.id,
    required this.phoneNumber,
    required this.fullName,
    required this.district,
    required this.taluk,
    required this.village,
    this.preferredLanguage = 'ta',
    this.primaryRole = AppRole.worker,
    this.isOfficialVerified = false,
    this.isAdviserVerified = false,
    this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      phoneNumber: json['phone_number'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      district: json['district'] as String? ?? '',
      taluk: json['taluk'] as String? ?? '',
      village: json['village'] as String? ?? '',
      preferredLanguage: json['preferred_language'] as String? ?? 'ta',
      primaryRole: AppRoleExtension.fromCode(json['primary_role'] as String? ?? 'worker'),
      isOfficialVerified: json['is_official_verified'] as bool? ?? false,
      isAdviserVerified: json['is_adviser_verified'] as bool? ?? false,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'full_name': fullName,
      'district': district,
      'taluk': taluk,
      'village': village,
      'preferred_language': preferredLanguage,
      'primary_role': primaryRole.code,
      'is_official_verified': isOfficialVerified,
      'is_adviser_verified': isAdviserVerified,
    };
  }

  UserProfile copyWith({
    String? fullName,
    String? district,
    String? taluk,
    String? village,
    String? preferredLanguage,
    AppRole? primaryRole,
    bool? isOfficialVerified,
    bool? isAdviserVerified,
  }) {
    return UserProfile(
      id: id,
      phoneNumber: phoneNumber,
      fullName: fullName ?? this.fullName,
      district: district ?? this.district,
      taluk: taluk ?? this.taluk,
      village: village ?? this.village,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      primaryRole: primaryRole ?? this.primaryRole,
      isOfficialVerified: isOfficialVerified ?? this.isOfficialVerified,
      isAdviserVerified: isAdviserVerified ?? this.isAdviserVerified,
      createdAt: createdAt,
    );
  }
}
