import 'package:flutter/foundation.dart';
import '../data/models/panchayat_models.dart';
import '../data/repositories/panchayat_repository.dart';
import '../core/services/storage_service.dart';

class PanchayatProvider extends ChangeNotifier {
  final PanchayatRepository _repo = PanchayatRepository();

  List<VillageAnnouncement> _announcements = [];
  List<GramSabhaMeeting> _gramSabhas = [];
  List<PublicFundRecord> _fundRecords = [];
  List<VillageComplaint> _complaints = [];
  bool _isLoading = false;

  List<VillageAnnouncement> get announcements => _announcements;
  List<GramSabhaMeeting> get gramSabhas => _gramSabhas;
  List<PublicFundRecord> get fundRecords => _fundRecords;
  List<VillageComplaint> get complaints => _complaints;
  bool get isLoading => _isLoading;

  PanchayatProvider() {
    loadAllPanchayatData();
  }

  Future<void> loadAllPanchayatData() async {
    _isLoading = true;
    notifyListeners();

    final village = StorageService.getVillage();
    final citizenId = StorageService.getUserId() ?? 'user';
    final isOfficial = StorageService.isOfficialVerified();

    _announcements = await _repo.fetchAnnouncements(village: village);
    _gramSabhas = await _repo.fetchGramSabhas(village: village);
    _fundRecords = await _repo.fetchFundRecords(village: village);
    _complaints = await _repo.fetchComplaints(citizenId: citizenId, isOfficial: isOfficial);

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> postAnnouncement({
    required String titleTa,
    required String titleEn,
    required String contentTa,
    required String contentEn,
    required String category,
    required bool isUrgent,
  }) async {
    final officialId = StorageService.getUserId() ?? 'official-user';
    final ann = VillageAnnouncement(
      id: 'ann-${DateTime.now().millisecondsSinceEpoch}',
      officialId: officialId,
      district: StorageService.getDistrict(),
      taluk: StorageService.getTaluk(),
      village: StorageService.getVillage(),
      titleTa: titleTa,
      titleEn: titleEn,
      contentTa: contentTa,
      contentEn: contentEn,
      category: category,
      isUrgent: isUrgent,
    );

    final success = await _repo.postAnnouncement(ann);
    await loadAllPanchayatData();
    return success;
  }

  Future<bool> postFundRecord({
    required String financialYear,
    required String projectNameTa,
    required String projectNameEn,
    required String fundingSource,
    required double allocatedAmount,
    required double spentAmount,
    required String projectStatus,
  }) async {
    final officialId = StorageService.getUserId() ?? 'official-user';
    final record = PublicFundRecord(
      id: 'fund-${DateTime.now().millisecondsSinceEpoch}',
      officialId: officialId,
      financialYear: financialYear,
      projectNameTa: projectNameTa,
      projectNameEn: projectNameEn,
      district: StorageService.getDistrict(),
      taluk: StorageService.getTaluk(),
      village: StorageService.getVillage(),
      fundingSource: fundingSource,
      allocatedAmount: allocatedAmount,
      spentAmount: spentAmount,
      projectStatus: projectStatus,
      isVerified: true,
    );

    final success = await _repo.postFundRecord(record);
    await loadAllPanchayatData();
    return success;
  }

  Future<bool> submitComplaint({
    required String category,
    required String description,
  }) async {
    final citizenId = StorageService.getUserId() ?? 'citizen-user';
    final comp = VillageComplaint(
      id: 'comp-${DateTime.now().millisecondsSinceEpoch}',
      citizenId: citizenId,
      district: StorageService.getDistrict(),
      taluk: StorageService.getTaluk(),
      village: StorageService.getVillage(),
      category: category,
      description: description,
      status: 'submitted',
    );

    final success = await _repo.submitComplaint(comp);
    await loadAllPanchayatData();
    return success;
  }

  Future<bool> resolveComplaint({
    required String complaintId,
    required String newStatus,
    required String officialResponse,
  }) async {
    final success = await _repo.updateComplaintStatus(complaintId, newStatus, officialResponse);
    await loadAllPanchayatData();
    return success;
  }
}
