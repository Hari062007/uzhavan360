class CropPriceListing {
  final String id;
  final String traderId;
  final String cropId;
  final String cropNameTa;
  final String cropNameEn;
  final String district;
  final String marketOrVillage;
  final String priceUnit; // quintal, kg, tonne
  final double grade1Price; // Top quality
  final double grade2Price; // Medium quality
  final double grade3Price; // Fair quality
  final String notes;
  final bool isActive;
  final DateTime updatedAt;

  CropPriceListing({
    required this.id,
    required this.traderId,
    required this.cropId,
    required this.cropNameTa,
    required this.cropNameEn,
    required this.district,
    required this.marketOrVillage,
    this.priceUnit = 'quintal',
    required this.grade1Price,
    required this.grade2Price,
    required this.grade3Price,
    this.notes = '',
    this.isActive = true,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  factory CropPriceListing.fromJson(Map<String, dynamic> json) {
    return CropPriceListing(
      id: json['id'] as String,
      traderId: json['trader_id'] as String,
      cropId: json['crop_id'] as String? ?? '',
      cropNameTa: json['crop_name_ta'] as String? ?? '',
      cropNameEn: json['crop_name_en'] as String? ?? '',
      district: json['district'] as String? ?? '',
      marketOrVillage: json['market_or_village'] as String? ?? '',
      priceUnit: json['price_unit'] as String? ?? 'quintal',
      grade1Price: (json['grade_1_price'] as num?)?.toDouble() ?? 0.0,
      grade2Price: (json['grade_2_price'] as num?)?.toDouble() ?? 0.0,
      grade3Price: (json['grade_3_price'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trader_id': traderId,
      'crop_id': cropId,
      'crop_name_ta': cropNameTa,
      'crop_name_en': cropNameEn,
      'district': district,
      'market_or_village': marketOrVillage,
      'price_unit': priceUnit,
      'grade_1_price': grade1Price,
      'grade_2_price': grade2Price,
      'grade_3_price': grade3Price,
      'notes': notes,
      'is_active': isActive,
    };
  }
}
