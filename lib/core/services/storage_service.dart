import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Language Preference
  static String getLanguage() => _prefs.getString('preferred_language') ?? 'ta';
  static Future<void> setLanguage(String lang) => _prefs.setString('preferred_language', lang);

  // Authentication & Profile Setup Status
  static bool isAuthenticated() => _prefs.getBool('is_authenticated') ?? false;
  static Future<void> setAuthenticated(bool val) => _prefs.setBool('is_authenticated', val);

  static bool isProfileComplete() => _prefs.getBool('is_profile_complete') ?? false;
  static Future<void> setProfileComplete(bool val) => _prefs.setBool('is_profile_complete', val);

  static String? getUserId() => _prefs.getString('user_id');
  static Future<void> setUserId(String id) => _prefs.setString('user_id', id);

  static String? getPhoneNumber() => _prefs.getString('user_phone');
  static Future<void> setPhoneNumber(String phone) => _prefs.setString('user_phone', phone);

  static String? getFullName() => _prefs.getString('full_name');
  static Future<void> setFullName(String name) => _prefs.setString('full_name', name);

  // Selected Village Location (Saved and reused)
  static String getDistrict() => _prefs.getString('user_district') ?? 'Madurai';
  static String getDistrictTa() => _prefs.getString('user_district_ta') ?? 'மதுரை';
  static String getTaluk() => _prefs.getString('user_taluk') ?? 'Vadipatti';
  static String getTalukTa() => _prefs.getString('user_taluk_ta') ?? 'வாடிப்பட்டி';
  static String getVillage() => _prefs.getString('user_village') ?? 'Alangottaram';
  static String getVillageTa() => _prefs.getString('user_village_ta') ?? 'ஆலங்கொட்டாரம்';

  static Future<void> setLocation({
    required String district,
    required String districtTa,
    required String taluk,
    required String talukTa,
    required String village,
    required String villageTa,
  }) async {
    await _prefs.setString('user_district', district);
    await _prefs.setString('user_district_ta', districtTa);
    await _prefs.setString('user_taluk', taluk);
    await _prefs.setString('user_taluk_ta', talukTa);
    await _prefs.setString('user_village', village);
    await _prefs.setString('user_village_ta', villageTa);
  }

  // Roles
  static String getPrimaryRole() => _prefs.getString('primary_role') ?? 'worker';
  static Future<void> setPrimaryRole(String role) => _prefs.setString('primary_role', role);

  static bool isOfficialVerified() => _prefs.getBool('is_official_verified') ?? false;
  static Future<void> setOfficialVerified(bool val) => _prefs.setBool('is_official_verified', val);

  // Cache with Timestamp for Offline Support
  static Future<void> cacheData(String key, String jsonPayload) async {
    await _prefs.setString('cache_$key', jsonPayload);
    await _prefs.setInt('cache_time_$key', DateTime.now().millisecondsSinceEpoch);
  }

  static String? getCachedData(String key) => _prefs.getString('cache_$key');

  static DateTime? getCacheTime(String key) {
    int? ms = _prefs.getInt('cache_time_$key');
    return ms != null ? DateTime.fromMillisecondsSinceEpoch(ms) : null;
  }

  // Clear session on logout
  static Future<void> clearSession() async {
    await _prefs.remove('is_authenticated');
    await _prefs.remove('user_id');
    await _prefs.remove('user_phone');
    await _prefs.remove('is_profile_complete');
    await _prefs.remove('is_official_verified');
    // Note: We retain preferred_language and village for convenience
  }
}
