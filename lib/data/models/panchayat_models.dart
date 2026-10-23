class VillageAnnouncement {
  final String id;
  final String officialId;
  final String district;
  final String taluk;
  final String village;
  final String titleTa;
  final String titleEn;
  final String contentTa;
  final String contentEn;
  final String category; // general, health, water, agriculture, power_cut, urgent
  final bool isUrgent;
  final DateTime createdAt;

  VillageAnnouncement({
    required this.id,
    required this.officialId,
    required this.district,
    required this.taluk,
    required this.village,
    required this.titleTa,
    required this.titleEn,
    required this.contentTa,
    required this.contentEn,
    this.category = 'general',
    this.isUrgent = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory VillageAnnouncement.fromJson(Map<String, dynamic> json) {
    return VillageAnnouncement(
      id: json['id'] as String,
      officialId: json['official_id'] as String? ?? '',
      district: json['district'] as String? ?? '',
      taluk: json['taluk'] as String? ?? '',
      village: json['village'] as String? ?? '',
      titleTa: json['title_ta'] as String? ?? '',
      titleEn: json['title_en'] as String? ?? '',
      contentTa: json['content_ta'] as String? ?? '',
      contentEn: json['content_en'] as String? ?? '',
      category: json['category'] as String? ?? 'general',
      isUrgent: json['is_urgent'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'official_id': officialId,
      'district': district,
      'taluk': taluk,
      'village': village,
      'title_ta': titleTa,
      'title_en': titleEn,
      'content_ta': contentTa,
      'content_en': contentEn,
      'category': category,
      'is_urgent': isUrgent,
    };
  }
}

class GramSabhaMeeting {
  final String id;
  final String officialId;
  final String district;
  final String taluk;
  final String village;
  final DateTime meetingDate;
  final String meetingTime;
  final String venue;
  final String agendaTa;
  final String agendaEn;
  final String? resolutionsSummaryTa;
  final String? resolutionsSummaryEn;
  final String status; // scheduled, ongoing, concluded, postponed

  GramSabhaMeeting({
    required this.id,
    required this.officialId,
    required this.district,
    required this.taluk,
    required this.village,
    required this.meetingDate,
    required this.meetingTime,
    required this.venue,
    required this.agendaTa,
    required this.agendaEn,
    this.resolutionsSummaryTa,
    this.resolutionsSummaryEn,
    this.status = 'scheduled',
  });

  factory GramSabhaMeeting.fromJson(Map<String, dynamic> json) {
    return GramSabhaMeeting(
      id: json['id'] as String,
      officialId: json['official_id'] as String? ?? '',
      district: json['district'] as String? ?? '',
      taluk: json['taluk'] as String? ?? '',
      village: json['village'] as String? ?? '',
      meetingDate: json['meeting_date'] != null
          ? DateTime.tryParse(json['meeting_date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      meetingTime: json['meeting_time'] as String? ?? '10:00 AM',
      venue: json['venue'] as String? ?? '',
      agendaTa: json['agenda_ta'] as String? ?? '',
      agendaEn: json['agenda_en'] as String? ?? '',
      resolutionsSummaryTa: json['resolutions_summary_ta'] as String?,
      resolutionsSummaryEn: json['resolutions_summary_en'] as String?,
      status: json['status'] as String? ?? 'scheduled',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'official_id': officialId,
      'district': district,
      'taluk': taluk,
      'village': village,
      'meeting_date': meetingDate.toIso8601String().split('T').first,
      'meeting_time': meetingTime,
      'venue': venue,
      'agenda_ta': agendaTa,
      'agenda_en': agendaEn,
      'resolutions_summary_ta': resolutionsSummaryTa,
      'resolutions_summary_en': resolutionsSummaryEn,
      'status': status,
    };
  }
}

class PublicFundRecord {
  final String id;
  final String officialId;
  final String financialYear;
  final String projectNameTa;
  final String projectNameEn;
  final String district;
  final String taluk;
  final String village;
  final String fundingSource;
  final double allocatedAmount;
  final double spentAmount;
  final double remainingAmount;
  final String projectStatus; // tender_phase, in_progress, completed, halted
  final String? referenceDocumentUrl;
  final bool isVerified;
  final DateTime updatedAt;

  PublicFundRecord({
    required this.id,
    required this.officialId,
    required this.financialYear,
    required this.projectNameTa,
    required this.projectNameEn,
    required this.district,
    required this.taluk,
    required this.village,
    required this.fundingSource,
    required this.allocatedAmount,
    required this.spentAmount,
    double? remainingAmount,
    this.projectStatus = 'in_progress',
    this.referenceDocumentUrl,
    this.isVerified = false,
    DateTime? updatedAt,
  })  : remainingAmount = remainingAmount ?? (allocatedAmount - spentAmount),
        updatedAt = updatedAt ?? DateTime.now();

  factory PublicFundRecord.fromJson(Map<String, dynamic> json) {
    double allocated = (json['allocated_amount'] as num?)?.toDouble() ?? 0.0;
    double spent = (json['spent_amount'] as num?)?.toDouble() ?? 0.0;
    return PublicFundRecord(
      id: json['id'] as String,
      officialId: json['official_id'] as String? ?? '',
      financialYear: json['financial_year'] as String? ?? '2025-2026',
      projectNameTa: json['project_name_ta'] as String? ?? '',
      projectNameEn: json['project_name_en'] as String? ?? '',
      district: json['district'] as String? ?? '',
      taluk: json['taluk'] as String? ?? '',
      village: json['village'] as String? ?? '',
      fundingSource: json['funding_source'] as String? ?? '',
      allocatedAmount: allocated,
      spentAmount: spent,
      remainingAmount: allocated - spent,
      projectStatus: json['project_status'] as String? ?? 'in_progress',
      referenceDocumentUrl: json['reference_document_url'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'official_id': officialId,
      'financial_year': financialYear,
      'project_name_ta': projectNameTa,
      'project_name_en': projectNameEn,
      'district': district,
      'taluk': taluk,
      'village': village,
      'funding_source': fundingSource,
      'allocated_amount': allocatedAmount,
      'spent_amount': spentAmount,
      'project_status': projectStatus,
      'reference_document_url': referenceDocumentUrl,
      'is_verified': isVerified,
    };
  }
}

class VillageComplaint {
  final String id;
  final String citizenId;
  final String district;
  final String taluk;
  final String village;
  final String category; // drinking_water, street_light, drainage, road, sanitation, agriculture, other
  final String description;
  final String? imageUrl;
  final String status; // submitted, under_review, action_taken, resolved, rejected
  final String? officialResponse;
  final DateTime createdAt;

  VillageComplaint({
    required this.id,
    required this.citizenId,
    required this.district,
    required this.taluk,
    required this.village,
    required this.category,
    required this.description,
    this.imageUrl,
    this.status = 'submitted',
    this.officialResponse,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory VillageComplaint.fromJson(Map<String, dynamic> json) {
    return VillageComplaint(
      id: json['id'] as String,
      citizenId: json['citizen_id'] as String? ?? '',
      district: json['district'] as String? ?? '',
      taluk: json['taluk'] as String? ?? '',
      village: json['village'] as String? ?? '',
      category: json['category'] as String? ?? 'general',
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      status: json['status'] as String? ?? 'submitted',
      officialResponse: json['official_response'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'citizen_id': citizenId,
      'district': district,
      'taluk': taluk,
      'village': village,
      'category': category,
      'description': description,
      'image_url': imageUrl,
      'status': status,
      'official_response': officialResponse,
    };
  }

  String get categoryLabelTa {
    switch (category) {
      case 'drinking_water':
        return 'குடிநீர் பிரச்சனை';
      case 'street_light':
        return 'தெருவிளக்கு பராமரிப்பு';
      case 'drainage':
        return 'சாக்கடை / கழிவுநீர்';
      case 'road':
        return 'சாலை சேதம்';
      case 'sanitation':
        return 'தூய்மைப் பணி';
      case 'agriculture':
        return 'விவசாய பாசன வாய்க்கால்';
      default:
        return 'பொதுவான குறைபாடு';
    }
  }
}
