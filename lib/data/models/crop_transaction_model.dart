class CropTransactionModel {
  final String id;
  final String cropId;
  final String cropName;
  final String qualityGrade; // grade_1, grade_2, grade_3
  final double transactionPrice;
  final String priceUnit;
  final double? quantitySold;
  final String marketOrVillage;
  final String district;
  final DateTime transactionDate;
  final String? reportedBy;
  final String source; // regulated_market, trader_direct, farmer_sale
  final bool isVerified;
  final String? verifiedBy;
  final DateTime createdAt;

  CropTransactionModel({
    required this.id,
    required this.cropId,
    required this.cropName,
    required this.qualityGrade,
    required this.transactionPrice,
    this.priceUnit = 'quintal',
    this.quantitySold,
    required this.marketOrVillage,
    required this.district,
    required this.transactionDate,
    this.reportedBy,
    required this.source,
    this.isVerified = false,
    this.verifiedBy,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory CropTransactionModel.fromJson(Map<String, dynamic> json) {
    return CropTransactionModel(
      id: json['id'] as String,
      cropId: json['crop_id'] as String? ?? '',
      cropName: json['crop_name'] as String? ?? '',
      qualityGrade: json['quality_grade'] as String? ?? 'grade_1',
      transactionPrice: (json['transaction_price'] as num?)?.toDouble() ?? 0.0,
      priceUnit: json['price_unit'] as String? ?? 'quintal',
      quantitySold: (json['quantity_sold'] as num?)?.toDouble(),
      marketOrVillage: json['market_or_village'] as String? ?? '',
      district: json['district'] as String? ?? '',
      transactionDate: json['transaction_date'] != null
          ? DateTime.tryParse(json['transaction_date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      reportedBy: json['reported_by'] as String?,
      source: json['source'] as String? ?? 'trader_direct',
      isVerified: json['is_verified'] as bool? ?? false,
      verifiedBy: json['verified_by'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'crop_id': cropId,
      'crop_name': cropName,
      'quality_grade': qualityGrade,
      'transaction_price': transactionPrice,
      'price_unit': priceUnit,
      'quantity_sold': quantitySold,
      'market_or_village': marketOrVillage,
      'district': district,
      'transaction_date': transactionDate.toIso8601String().split('T').first,
      'reported_by': reportedBy,
      'source': source,
      'is_verified': isVerified,
    };
  }

  String get qualityGradeLabelTa {
    switch (qualityGrade) {
      case 'grade_1':
        return 'முதல் தரம் (Grade 1)';
      case 'grade_2':
        return 'இரண்டாம் தரம் (Grade 2)';
      case 'grade_3':
        return 'மூன்றாம் தரம் (Grade 3)';
      default:
        return qualityGrade;
    }
  }
}
