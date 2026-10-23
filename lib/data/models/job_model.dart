class JobModel {
  final String id;
  final String employerId;
  final String titleTa;
  final String titleEn;
  final String workType;
  final String district;
  final String taluk;
  final String village;
  final DateTime workDate;
  final String workingHours;
  final int workersRequired;
  final int workersHired;
  final double wageAmount;
  final String wageBasis;
  final String description;
  final String contactPhone;
  final String status;
  final DateTime createdAt;

  JobModel({
    required this.id,
    required this.employerId,
    required this.titleTa,
    required this.titleEn,
    required this.workType,
    required this.district,
    required this.taluk,
    required this.village,
    required this.workDate,
    this.workingHours = '8:00 AM - 2:00 PM',
    required this.workersRequired,
    this.workersHired = 0,
    required this.wageAmount,
    this.wageBasis = 'daily',
    this.description = '',
    required this.contactPhone,
    this.status = 'open',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] as String,
      employerId: json['employer_id'] as String,
      titleTa: json['title_ta'] as String? ?? 'விவசாய வேலை',
      titleEn: json['title_en'] as String? ?? 'Farm Work',
      workType: json['work_type'] as String? ?? 'harvesting',
      district: json['district'] as String? ?? '',
      taluk: json['taluk'] as String? ?? '',
      village: json['village'] as String? ?? '',
      workDate: json['work_date'] != null
          ? DateTime.tryParse(json['work_date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      workingHours: json['working_hours'] as String? ?? '8:00 AM - 2:00 PM',
      workersRequired: (json['workers_required'] as num?)?.toInt() ?? 1,
      workersHired: (json['workers_hired'] as num?)?.toInt() ?? 0,
      wageAmount: (json['wage_amount'] as num?)?.toDouble() ?? 500.0,
      wageBasis: json['wage_basis'] as String? ?? 'daily',
      description: json['description'] as String? ?? '',
      contactPhone: json['contact_phone'] as String? ?? '',
      status: json['status'] as String? ?? 'open',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employer_id': employerId,
      'title_ta': titleTa,
      'title_en': titleEn,
      'work_type': workType,
      'district': district,
      'taluk': taluk,
      'village': village,
      'work_date': workDate.toIso8601String().split('T').first,
      'working_hours': workingHours,
      'workers_required': workersRequired,
      'workers_hired': workersHired,
      'wage_amount': wageAmount,
      'wage_basis': wageBasis,
      'description': description,
      'contact_phone': contactPhone,
      'status': status,
    };
  }

  bool get isOpen => status == 'open' && workersHired < workersRequired;
}
