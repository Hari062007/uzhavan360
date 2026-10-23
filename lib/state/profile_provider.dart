import 'package:flutter/foundation.dart';
import '../data/models/user_profile.dart';
import '../data/models/user_role.dart';
import '../data/repositories/profile_repository.dart';
import '../core/services/storage_service.dart';
import '../core/services/location_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _profileRepo = ProfileRepository();

  UserProfile? _profile;
  bool _isLoading = false;

  String _fullName = '';
  String _selectedDistrict = 'Madurai';
  String _selectedDistrictTa = 'மதுரை';
  String _selectedTaluk = 'Vadipatti';
  String _selectedTalukTa = 'வாடிப்பட்டி';
  String _selectedVillage = 'Alangottaram';
  String _selectedVillageTa = 'ஆலங்கொட்டாரம்';
  AppRole _selectedRole = AppRole.worker;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;

  String get fullName => _fullName;
  String get selectedDistrict => _selectedDistrict;
  String get selectedDistrictTa => _selectedDistrictTa;
  String get selectedTaluk => _selectedTaluk;
  String get selectedTalukTa => _selectedTalukTa;
  String get selectedVillage => _selectedVillage;
  String get selectedVillageTa => _selectedVillageTa;
  AppRole get selectedRole => _selectedRole;

  bool get isOfficialVerified => _profile?.isOfficialVerified ?? StorageService.isOfficialVerified();

  ProfileProvider() {
    _loadInitialState();
  }

  void _loadInitialState() {
    _fullName = StorageService.getFullName() ?? '';
    _selectedDistrict = StorageService.getDistrict();
    _selectedDistrictTa = StorageService.getDistrictTa();
    _selectedTaluk = StorageService.getTaluk();
    _selectedTalukTa = StorageService.getTalukTa();
    _selectedVillage = StorageService.getVillage();
    _selectedVillageTa = StorageService.getVillageTa();
    _selectedRole = AppRoleExtension.fromCode(StorageService.getPrimaryRole());
  }

  void setFullName(String name) {
    _fullName = name;
    notifyListeners();
  }

  void setLocation({
    required String district,
    required String districtTa,
    required String taluk,
    required String talukTa,
    required String village,
    required String villageTa,
  }) {
    _selectedDistrict = district;
    _selectedDistrictTa = districtTa;
    _selectedTaluk = taluk;
    _selectedTalukTa = talukTa;
    _selectedVillage = village;
    _selectedVillageTa = villageTa;
    notifyListeners();
  }

  Future<void> autoDetectLocation() async {
    _isLoading = true;
    notifyListeners();

    final detected = await LocationService.detectLocation();
    _selectedDistrict = 'Madurai';
    _selectedDistrictTa = 'மதுரை';
    _selectedTaluk = 'Vadipatti';
    _selectedTalukTa = 'வாடிப்பட்டி';
    _selectedVillage = detected.name;
    _selectedVillageTa = detected.nameTa;

    _isLoading = false;
    notifyListeners();
  }

  void setRole(AppRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  Future<bool> saveProfileSetup() async {
    _isLoading = true;
    notifyListeners();

    final userId = StorageService.getUserId() ?? 'user-${DateTime.now().millisecondsSinceEpoch}';
    final phone = StorageService.getPhoneNumber() ?? '';

    // If user selected Panchayat Official, they start as unverified until authorized!
    final profile = UserProfile(
      id: userId,
      phoneNumber: phone,
      fullName: _fullName,
      district: _selectedDistrict,
      taluk: _selectedTaluk,
      village: _selectedVillage,
      preferredLanguage: StorageService.getLanguage(),
      primaryRole: _selectedRole,
      isOfficialVerified: false, // Strict: never self-elevate
    );

    final success = await _profileRepo.saveProfile(profile);
    _profile = profile;
    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> fetchCurrentProfile() async {
    final userId = StorageService.getUserId();
    if (userId != null) {
      _isLoading = true;
      notifyListeners();
      _profile = await _profileRepo.fetchProfile(userId);
      if (_profile != null) {
        _fullName = _profile!.fullName;
        _selectedRole = _profile!.primaryRole;
        _selectedDistrict = _profile!.district;
        _selectedTaluk = _profile!.taluk;
        _selectedVillage = _profile!.village;
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Admin verification toggle for testing / approval simulation
  Future<void> toggleOfficialVerification(bool verified) async {
    await StorageService.setOfficialVerified(verified);
    if (_profile != null) {
      _profile = _profile!.copyWith(isOfficialVerified: verified);
    }
    notifyListeners();
  }
}
