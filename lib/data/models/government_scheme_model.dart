class GovernmentSchemeModel {
  final String id;
  final String titleTa;
  final String titleEn;
  final String department;
  final String summaryTa;
  final String summaryEn;
  final String eligibilityTa;
  final String eligibilityEn;
  final String benefitsTa;
  final String benefitsEn;
  final List<String> documentsRequiredTa;
  final List<String> documentsRequiredEn;
  final String applicationProcessTa;
  final String applicationProcessEn;
  final String? officialPortalUrl;
  final String? helplineNumber;
  final DateTime? deadlineDate;
  final bool isActive;

  GovernmentSchemeModel({
    required this.id,
    required this.titleTa,
    required this.titleEn,
    required this.department,
    required this.summaryTa,
    required this.summaryEn,
    required this.eligibilityTa,
    required this.eligibilityEn,
    required this.benefitsTa,
    required this.benefitsEn,
    required this.documentsRequiredTa,
    required this.documentsRequiredEn,
    required this.applicationProcessTa,
    required this.applicationProcessEn,
    this.officialPortalUrl,
    this.helplineNumber,
    this.deadlineDate,
    this.isActive = true,
  });

  factory GovernmentSchemeModel.fromJson(Map<String, dynamic> json) {
    return GovernmentSchemeModel(
      id: json['id'] as String,
      titleTa: json['title_ta'] as String? ?? '',
      titleEn: json['title_en'] as String? ?? '',
      department: json['department'] as String? ?? '',
      summaryTa: json['summary_ta'] as String? ?? '',
      summaryEn: json['summary_en'] as String? ?? '',
      eligibilityTa: json['eligibility_ta'] as String? ?? '',
      eligibilityEn: json['eligibility_en'] as String? ?? '',
      benefitsTa: json['benefits_ta'] as String? ?? '',
      benefitsEn: json['benefits_en'] as String? ?? '',
      documentsRequiredTa: (json['documents_required_ta'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      documentsRequiredEn: (json['documents_required_en'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      applicationProcessTa: json['application_process_ta'] as String? ?? '',
      applicationProcessEn: json['application_process_en'] as String? ?? '',
      officialPortalUrl: json['official_portal_url'] as String?,
      helplineNumber: json['helpline_number'] as String?,
      deadlineDate: json['deadline_date'] != null
          ? DateTime.tryParse(json['deadline_date'].toString())
          : null,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_ta': titleTa,
      'title_en': titleEn,
      'department': department,
      'summary_ta': summaryTa,
      'summary_en': summaryEn,
      'eligibility_ta': eligibilityTa,
      'eligibility_en': eligibilityEn,
      'benefits_ta': benefitsTa,
      'benefits_en': benefitsEn,
      'documents_required_ta': documentsRequiredTa,
      'documents_required_en': documentsRequiredEn,
      'application_process_ta': applicationProcessTa,
      'application_process_en': applicationProcessEn,
      'official_portal_url': officialPortalUrl,
      'helpline_number': helplineNumber,
      'is_active': isActive,
    };
  }
}
