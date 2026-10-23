class AdviserModel {
  final String id;
  final String fullName;
  final String district;
  final String village;
  final List<String> specializationsTa;
  final List<String> specializationsEn;
  final int experienceYears;
  final String availableHours;
  final double rating;
  final int reviewsCount;
  final String contactPhone;
  final bool isVerified;

  AdviserModel({
    required this.id,
    required this.fullName,
    required this.district,
    required this.village,
    required this.specializationsTa,
    required this.specializationsEn,
    required this.experienceYears,
    this.availableHours = '5:00 PM - 7:00 PM',
    this.rating = 4.9,
    this.reviewsCount = 18,
    required this.contactPhone,
    this.isVerified = true,
  });

  factory AdviserModel.fromJson(Map<String, dynamic> json) {
    return AdviserModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? '',
      district: json['district'] as String? ?? '',
      village: json['village'] as String? ?? '',
      specializationsTa: (json['specializations_ta'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      specializationsEn: (json['specializations_en'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      experienceYears: (json['experience_years'] as num?)?.toInt() ?? 10,
      availableHours: json['available_hours'] as String? ?? '5:00 PM - 7:00 PM',
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      reviewsCount: (json['reviews_count'] as num?)?.toInt() ?? 0,
      contactPhone: json['contact_phone'] as String? ?? '',
      isVerified: json['is_verified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'district': district,
      'village': village,
      'specializations_ta': specializationsTa,
      'specializations_en': specializationsEn,
      'experience_years': experienceYears,
      'available_hours': availableHours,
      'rating': rating,
      'reviews_count': reviewsCount,
      'contact_phone': contactPhone,
      'is_verified': isVerified,
    };
  }
}
