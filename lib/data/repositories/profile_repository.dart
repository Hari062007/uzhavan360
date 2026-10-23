import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/supabase_config.dart';
import '../../core/services/storage_service.dart';
import '../models/user_profile.dart';
import '../models/user_role.dart';

class ProfileRepository {
  Future<UserProfile?> fetchProfile(String userId) async {
    if (SupabaseConfig.isConfigured) {
      try {
        final res = await Supabase.instance.client
            .from('profiles')
            .select()
            .eq('id', userId)
            .maybeSingle();

        if (res != null) {
          final profile = UserProfile.fromJson(res);
          await StorageService.setFullName(profile.fullName);
          await StorageService.setPrimaryRole(profile.primaryRole.code);
          await StorageService.setOfficialVerified(profile.isOfficialVerified);
          return profile;
        }
      } catch (_) {}
    }

    // Fallback to locally cached profile
    final phone = StorageService.getPhoneNumber() ?? '';
    final name = StorageService.getFullName() ?? '';
    final district = StorageService.getDistrict();
    final taluk = StorageService.getTaluk();
    final village = StorageService.getVillage();
    final role = AppRoleExtension.fromCode(StorageService.getPrimaryRole());
    final isVerified = StorageService.isOfficialVerified();

    if (name.isNotEmpty) {
      return UserProfile(
        id: userId,
        phoneNumber: phone,
        fullName: name,
        district: district,
        taluk: taluk,
        village: village,
        primaryRole: role,
        isOfficialVerified: isVerified,
      );
    }
    return null;
  }

  Future<bool> saveProfile(UserProfile profile) async {
    // 1. Cache locally first
    await StorageService.setFullName(profile.fullName);
    await StorageService.setPhoneNumber(profile.phoneNumber);
    await StorageService.setPrimaryRole(profile.primaryRole.code);
    await StorageService.setLocation(
      district: profile.district,
      districtTa: profile.district,
      taluk: profile.taluk,
      talukTa: profile.taluk,
      village: profile.village,
      villageTa: profile.village,
    );
    await StorageService.setOfficialVerified(profile.isOfficialVerified);
    await StorageService.setProfileComplete(true);

    // 2. Synchronize to Supabase if configured
    if (SupabaseConfig.isConfigured) {
      try {
        await Supabase.instance.client
            .from('profiles')
            .upsert(profile.toJson());
        return true;
      } catch (_) {
        return false;
      }
    }
    return true;
  }
}
