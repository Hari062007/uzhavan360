import 'package:flutter/foundation.dart';
import '../data/models/job_model.dart';
import '../data/models/job_application_model.dart';
import '../data/repositories/job_repository.dart';
import '../core/services/storage_service.dart';

class JobProvider extends ChangeNotifier {
  final JobRepository _jobRepo = JobRepository();

  List<JobModel> _jobs = [];
  List<JobApplicationModel> _myApplications = [];
  bool _isLoading = false;
  String _selectedWorkType = '';
  String? _errorMessage;

  List<JobModel> get jobs => _jobs;
  List<JobApplicationModel> get myApplications => _myApplications;
  bool get isLoading => _isLoading;
  String get selectedWorkType => _selectedWorkType;
  String? get errorMessage => _errorMessage;

  JobProvider() {
    loadJobs();
  }

  void setWorkTypeFilter(String type) {
    _selectedWorkType = type;
    loadJobs();
  }

  Future<void> loadJobs() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _jobs = await _jobRepo.fetchJobs(
        district: StorageService.getDistrict(),
        village: StorageService.getVillage(),
        workType: _selectedWorkType,
      );
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> postJob({
    required String titleTa,
    required String titleEn,
    required String workType,
    required DateTime workDate,
    required String workingHours,
    required int workersRequired,
    required double wageAmount,
    required String wageBasis,
    required String description,
    required String contactPhone,
  }) async {
    _isLoading = true;
    notifyListeners();

    final userId = StorageService.getUserId() ?? 'user-employer';
    final job = JobModel(
      id: 'job-${DateTime.now().millisecondsSinceEpoch}',
      employerId: userId,
      titleTa: titleTa,
      titleEn: titleEn,
      workType: workType,
      district: StorageService.getDistrict(),
      taluk: StorageService.getTaluk(),
      village: StorageService.getVillage(),
      workDate: workDate,
      workingHours: workingHours,
      workersRequired: workersRequired,
      wageAmount: wageAmount,
      wageBasis: wageBasis,
      description: description,
      contactPhone: contactPhone,
    );

    final success = await _jobRepo.createJob(job);
    await loadJobs();
    return success;
  }

  Future<bool> applyForJob({
    required String jobId,
    required bool shareContactConsent,
    required String contactPhone,
  }) async {
    final userId = StorageService.getUserId() ?? 'worker-user';

    // Check if already applied
    if (_myApplications.any((a) => a.jobId == jobId)) {
      return true;
    }

    final application = JobApplicationModel(
      id: 'app-${DateTime.now().millisecondsSinceEpoch}',
      jobId: jobId,
      workerId: userId,
      shareContactConsent: shareContactConsent,
      contactPhone: shareContactConsent ? contactPhone : null,
      status: 'pending',
    );

    final success = await _jobRepo.applyForJob(application);
    if (success) {
      _myApplications.add(application);
      notifyListeners();
    }
    return success;
  }

  Future<void> loadMyApplications() async {
    final userId = StorageService.getUserId() ?? 'worker-user';
    _myApplications = await _jobRepo.fetchMyApplications(userId);
    notifyListeners();
  }

  bool hasApplied(String jobId) {
    return _myApplications.any((a) => a.jobId == jobId);
  }
}
