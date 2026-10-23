import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/supabase_config.dart';
import '../../core/services/storage_service.dart';
import '../models/panchayat_models.dart';

class PanchayatRepository {
  final List<VillageAnnouncement> _sampleAnnouncements = [
    VillageAnnouncement(
      id: 'ann-1',
      officialId: 'official-vadipatti',
      district: 'Madurai',
      taluk: 'Vadipatti',
      village: 'Alangottaram',
      titleTa: 'விவசாய மின் இணைப்பு மற்றும் கால்வாய் தூர்வாருதல் பணி',
      titleEn: 'Agricultural Power Connection & Canal Desilting',
      contentTa: 'கிராமத்தின் பாசன வாய்க்கால் தூர்வாரும் பணி வரும் திங்கள் முதல் தொடங்குகிறது. விவசாயிகள் தங்கள் நில வரப்புகளை தயார் நிலையில் வைக்கவும்.',
      contentEn: 'Irrigation canal desilting commences this Monday. Farmers are requested to prepare their channel bunds.',
      category: 'agriculture',
      isUrgent: false,
    ),
    VillageAnnouncement(
      id: 'ann-2',
      officialId: 'official-vadipatti',
      district: 'Madurai',
      taluk: 'Vadipatti',
      village: 'Alangottaram',
      titleTa: 'முக்கிய குடிநீர் விநியோக பராமரிப்பு அறிவிப்பு',
      titleEn: 'Important Drinking Water Pipe Maintenance Notice',
      contentTa: 'மேல்நிலை நீர்த்தேக்க தொட்டி சுத்திகரிப்பு காரணமாக நாளை காலை 9 மணி முதல் மதியம் 2 மணி வரை குடிநீர் விநியோகம் நிறுத்தப்படும்.',
      contentEn: 'Overhead tank cleaning scheduled tomorrow between 9 AM to 2 PM. Water supply temporarily paused.',
      category: 'water',
      isUrgent: true,
    ),
  ];

  final List<GramSabhaMeeting> _sampleGramSabhas = [
    GramSabhaMeeting(
      id: 'gs-1',
      officialId: 'official-vadipatti',
      district: 'Madurai',
      taluk: 'Vadipatti',
      village: 'Alangottaram',
      meetingDate: DateTime(2026, 11, 1),
      meetingTime: '10:30 AM',
      venue: 'பஞ்சாயத்து ஒன்றிய தொடக்கப்பள்ளி வளாகம்',
      agendaTa: '1. கிராம வளர்ச்சி திட்ட ஒப்புதல்\n2. மகாத்மா காந்தி தேசிய ஊரக வேலை உறுதித் திட்டம் நிதி கணக்கு சமர்ப்பித்தல்\n3. கிராம குடிநீர் வடிகால் திட்ட மதிப்பீடு',
      agendaEn: '1. Village development plan approval\n2. MGNREGA social audit and accounts\n3. Drinking water and sanitation review',
      status: 'scheduled',
    ),
  ];

  final List<PublicFundRecord> _sampleFundRecords = [
    PublicFundRecord(
      id: 'fund-1',
      officialId: 'official-vadipatti',
      financialYear: '2025-2026',
      projectNameTa: 'மேற்கு தெரு தார் சாலை அமைத்தல் மற்றும் கான்கிரீட் வடிகால்',
      projectNameEn: 'West Street Tar Road & Concrete Drainage',
      district: 'Madurai',
      taluk: 'Vadipatti',
      village: 'Alangottaram',
      fundingSource: '15-வது நிதி ஆணைய மானியம் (15th Finance Commission)',
      allocatedAmount: 850000.0,
      spentAmount: 620000.0,
      projectStatus: 'in_progress',
      isVerified: true,
    ),
    PublicFundRecord(
      id: 'fund-2',
      officialId: 'official-vadipatti',
      financialYear: '2025-2026',
      projectNameTa: 'சூரிய மின்சக்தியுடன் கூடிய ஆழ்குழாய் கிணறு மற்றும் மேல்நிலை நீர்த்தேக்க தொட்டி',
      projectNameEn: 'Solar-Powered Borewell & Overhead Water Tank',
      district: 'Madurai',
      taluk: 'Vadipatti',
      village: 'Alangottaram',
      fundingSource: 'ஜல் ஜீவன் இயக்கம் (Jal Jeevan Mission)',
      allocatedAmount: 1200000.0,
      spentAmount: 1180000.0,
      projectStatus: 'completed',
      isVerified: true,
    ),
  ];

  final List<VillageComplaint> _sampleComplaints = [
    VillageComplaint(
      id: 'comp-1',
      citizenId: 'citizen-vadipatti-1',
      district: 'Madurai',
      taluk: 'Vadipatti',
      village: 'Alangottaram',
      category: 'street_light',
      description: 'வடக்கு தெரு பிள்ளையார் கோவில் அருகில் இரண்டு தெருவிளக்குகள் எரியவில்லை.',
      status: 'action_taken',
      officialResponse: 'பஞ்சாயத்து மின் பணியாளருக்கு உத்தரவிடப்பட்டு புதிய எல்இடி விளக்குகள் பொருத்தப்பட்டுள்ளன.',
    ),
  ];

  // Announcements
  Future<List<VillageAnnouncement>> fetchAnnouncements({String? village}) async {
    if (SupabaseConfig.isConfigured) {
      try {
        final res = await Supabase.instance.client
            .from('village_announcements')
            .select()
            .order('created_at', ascending: false);
        final list = (res as List).map((a) => VillageAnnouncement.fromJson(a)).toList();
        await StorageService.cacheData('announcements', jsonEncode(res));
        return list;
      } catch (_) {}
    }

    final cached = StorageService.getCachedData('announcements');
    if (cached != null) {
      try {
        final decoded = jsonDecode(cached) as List;
        return decoded.map((a) => VillageAnnouncement.fromJson(a)).toList();
      } catch (_) {}
    }

    return _sampleAnnouncements;
  }

  Future<bool> postAnnouncement(VillageAnnouncement ann) async {
    _sampleAnnouncements.insert(0, ann);
    if (SupabaseConfig.isConfigured) {
      try {
        await Supabase.instance.client.from('village_announcements').insert(ann.toJson());
        return true;
      } catch (_) {
        return false;
      }
    }
    return true;
  }

  // Gram Sabha
  Future<List<GramSabhaMeeting>> fetchGramSabhas({String? village}) async {
    if (SupabaseConfig.isConfigured) {
      try {
        final res = await Supabase.instance.client
            .from('gram_sabha_meetings')
            .select()
            .order('meeting_date', ascending: false);
        return (res as List).map((g) => GramSabhaMeeting.fromJson(g)).toList();
      } catch (_) {}
    }
    return _sampleGramSabhas;
  }

  // Public Fund Records
  Future<List<PublicFundRecord>> fetchFundRecords({String? village}) async {
    if (SupabaseConfig.isConfigured) {
      try {
        final res = await Supabase.instance.client
            .from('public_fund_records')
            .select()
            .order('created_at', ascending: false);
        final list = (res as List).map((f) => PublicFundRecord.fromJson(f)).toList();
        await StorageService.cacheData('funds', jsonEncode(res));
        return list;
      } catch (_) {}
    }

    final cached = StorageService.getCachedData('funds');
    if (cached != null) {
      try {
        final decoded = jsonDecode(cached) as List;
        return decoded.map((f) => PublicFundRecord.fromJson(f)).toList();
      } catch (_) {}
    }

    return _sampleFundRecords;
  }

  Future<bool> postFundRecord(PublicFundRecord record) async {
    _sampleFundRecords.insert(0, record);
    if (SupabaseConfig.isConfigured) {
      try {
        await Supabase.instance.client.from('public_fund_records').insert(record.toJson());
        return true;
      } catch (_) {
        return false;
      }
    }
    return true;
  }

  // Complaints
  Future<List<VillageComplaint>> fetchComplaints({required String citizenId, bool isOfficial = false}) async {
    if (SupabaseConfig.isConfigured) {
      try {
        var query = Supabase.instance.client.from('village_complaints').select();
        if (!isOfficial) {
          query = query.eq('citizen_id', citizenId);
        }
        final res = await query.order('created_at', ascending: false);
        return (res as List).map((c) => VillageComplaint.fromJson(c)).toList();
      } catch (_) {}
    }
    return isOfficial ? _sampleComplaints : _sampleComplaints.where((c) => c.citizenId == citizenId).toList();
  }

  Future<bool> submitComplaint(VillageComplaint complaint) async {
    _sampleComplaints.insert(0, complaint);
    if (SupabaseConfig.isConfigured) {
      try {
        await Supabase.instance.client.from('village_complaints').insert(complaint.toJson());
        return true;
      } catch (_) {
        return false;
      }
    }
    return true;
  }

  Future<bool> updateComplaintStatus(String id, String newStatus, String responseText) async {
    final idx = _sampleComplaints.indexWhere((c) => c.id == id);
    if (idx != -1) {
      final old = _sampleComplaints[idx];
      _sampleComplaints[idx] = VillageComplaint(
        id: old.id,
        citizenId: old.citizenId,
        district: old.district,
        taluk: old.taluk,
        village: old.village,
        category: old.category,
        description: old.description,
        status: newStatus,
        officialResponse: responseText,
        createdAt: old.createdAt,
      );
    }
    return true;
  }
}
