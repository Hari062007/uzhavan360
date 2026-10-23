class JobApplicationModel {
  final String id;
  final String jobId;
  final String workerId;
  final bool shareContactConsent;
  final String? contactPhone;
  final String status; // pending, accepted, rejected, cancelled
  final DateTime appliedAt;

  JobApplicationModel({
    required this.id,
    required this.jobId,
    required this.workerId,
    required this.shareContactConsent,
    this.contactPhone,
    this.status = 'pending',
    DateTime? appliedAt,
  }) : appliedAt = appliedAt ?? DateTime.now();

  factory JobApplicationModel.fromJson(Map<String, dynamic> json) {
    return JobApplicationModel(
      id: json['id'] as String,
      jobId: json['job_id'] as String,
      workerId: json['worker_id'] as String,
      shareContactConsent: json['share_contact_consent'] as bool? ?? false,
      contactPhone: json['contact_phone'] as String?,
      status: json['status'] as String? ?? 'pending',
      appliedAt: json['applied_at'] != null
          ? DateTime.tryParse(json['applied_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_id': jobId,
      'worker_id': workerId,
      'share_contact_consent': shareContactConsent,
      'contact_phone': contactPhone,
      'status': status,
    };
  }
}
