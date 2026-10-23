import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/supabase_config.dart';
import '../../core/services/storage_service.dart';
import '../models/government_scheme_model.dart';

class SchemeRepository {
  final List<GovernmentSchemeModel> _sampleSchemes = [
    GovernmentSchemeModel(
      id: 'scheme-1',
      titleTa: 'கலைஞரின் அனைத்து கிராம ஒருங்கிணைந்த வேளாண் வளர்ச்சி திட்டம்',
      titleEn: 'Kalaignarin All Village Integrated Agriculture Development Programme',
      department: 'வேளாண்மை - உழவர் நலத்துறை (Agriculture and Farmers Welfare Dept)',
      summaryTa: 'கிராம பஞ்சாயத்துகளில் உள்ள அனைத்து தரிசு நிலங்களையும் சாகுபடிக்கு கொண்டு வந்து, உழவர் வருமானத்தை பெருக்குதல்.',
      summaryEn: 'Brings fallow lands into cultivation across village panchayats and enhances farmer income.',
      eligibilityTa: 'அனைத்து சிறு, குறு மற்றும் ஆதிதிராவிட, பழங்குடியின விவசாயிகள்.',
      eligibilityEn: 'All small, marginal, SC and ST farmers owning agricultural land in selected panchayats.',
      benefitsTa: 'இலவச பழக்கன்றுகள், தார்ப்பாய், விசைத்தெளிப்பான், நுண்ணீர் பாசனத்திற்கான 100% மானியம்.',
      benefitsEn: 'Free fruit saplings, tarpaulins, power sprayers, and 100% subsidy for micro-irrigation.',
      documentsRequiredTa: ['பட்டா / சிட்டா நகல்', 'ஆதார் அட்டை', 'வங்கி கணக்கு புத்தக நகல்', 'புகைப்படம்'],
      documentsRequiredEn: ['Patta / Chitta copy', 'Aadhaar Card', 'Bank Passbook copy', 'Passport size photo'],
      applicationProcessTa: 'உங்கள் வட்டார வேளாண்மை உதவி இயக்குநர் அலுவலகம் அல்லது உழவன் செயலி மூலம் விண்ணப்பிக்கலாம்.',
      applicationProcessEn: 'Apply via Block Assistant Director of Agriculture Office or Uzhavan App.',
      officialPortalUrl: 'https://www.tnagrisnet.tn.gov.in',
      helplineNumber: '1800-425-1555',
    ),
    GovernmentSchemeModel(
      id: 'scheme-2',
      titleTa: 'பிரதம மந்திரி கிசான் சம்மான் நிதி (PM-KISAN)',
      titleEn: 'PM Kisan Samman Nidhi Yojana',
      department: 'மத்திய வேளாண்மை அமைச்சகம் (Ministry of Agriculture)',
      summaryTa: 'சிறு மற்றும் குறு விவசாயிகளுக்கு ஆண்டுக்கு ரூ. 6,000 நேரடி நிதி உதவி மூன்று தவணைகளாக வழங்கப்படுகிறது.',
      summaryEn: 'Direct income support of Rs. 6,000 per year in three equal installments to farmer families.',
      eligibilityTa: 'விவசாய நிலம் சொந்தமாக வைத்துள்ள அனைத்து விவசாய குடும்பங்கள்.',
      eligibilityEn: 'All landholding farmer families with cultivable land.',
      benefitsTa: 'ஆண்டுக்கு ரூ. 6,000 (தலா ரூ. 2,000 வீதம் 3 தவணைகளில் வங்கிக் கணக்கில் வரவு வைக்கப்படும்).',
      benefitsEn: 'Rs. 6,000 annually credited directly to bank account in 3 installments.',
      documentsRequiredTa: ['ஆதார் அட்டை', 'நிலப் பட்டா / ஆவணங்கள்', 'ஆதார் இணைக்கப்பட்ட வங்கிக் கணக்கு'],
      documentsRequiredEn: ['Aadhaar Card', 'Land Patta / Ownership records', 'Aadhaar linked Bank Account'],
      applicationProcessTa: 'PM-KISAN இணையதளம் அல்லது இ-சேவை மையம் மூலம் விண்ணப்பிக்கலாம்.',
      applicationProcessEn: 'Apply online at PM-KISAN portal or through local e-Seva centres.',
      officialPortalUrl: 'https://pmkisan.gov.in',
      helplineNumber: '155261',
    ),
    GovernmentSchemeModel(
      id: 'scheme-3',
      titleTa: 'பிரதம மந்திரி பயிர் காப்பீட்டுத் திட்டம் (PMFBY)',
      titleEn: 'Pradhan Mantri Fasal Bima Yojana (Crop Insurance)',
      department: 'வேளாண்மை - உழவர் நலத்துறை',
      summaryTa: 'இயற்கை சீற்றங்கள், வறட்சி, வெள்ளம் மற்றும் பூச்சித் தாக்குதலால் ஏற்படும் பயிர் இழப்பிற்கு முழுமையான காப்பீடு.',
      summaryEn: 'Comprehensive insurance cover against crop loss due to non-preventable natural risks.',
      eligibilityTa: 'அறிவிக்கப்பட்ட பகுதியில் பயிர் செய்யும் குத்தகை விவசாயிகள் உட்பட அனைத்து விவசாயிகளும்.',
      eligibilityEn: 'All farmers growing notified crops in notified areas, including tenant farmers.',
      benefitsTa: 'பயிர் சேதத்திற்கு குறைந்த பிரீமியத்தில் முழுமையான இழப்பீட்டுத் தொகை வழங்கப்படுகிறது.',
      benefitsEn: 'Financial support and claim payout for crop loss at very nominal premium.',
      documentsRequiredTa: ['அடங்கல் / சாகுபடி சான்று', 'பட்டா / சிட்டா', 'ஆதார் அட்டை', 'வங்கி பாஸ்புக்'],
      documentsRequiredEn: ['Adangal / Sowing certificate', 'Patta / Chitta', 'Aadhaar Card', 'Bank Passbook'],
      applicationProcessTa: 'தொடர் கூட்டுறவு வங்கிகள், பொதுத்துறை வங்கிகள் அல்லது இ-சேவை மையம் வாயிலாக பதிவு செய்யவும்.',
      applicationProcessEn: 'Enroll through Primary Agricultural Co-op Societies, Banks, or CSC centres.',
      officialPortalUrl: 'https://pmfby.gov.in',
      helplineNumber: '1800-180-1551',
    ),
  ];

  Future<List<GovernmentSchemeModel>> fetchSchemes() async {
    if (SupabaseConfig.isConfigured) {
      try {
        final res = await Supabase.instance.client
            .from('government_schemes')
            .select()
            .eq('is_active', true)
            .order('created_at', ascending: false);

        final list = (res as List).map((s) => GovernmentSchemeModel.fromJson(s)).toList();
        await StorageService.cacheData('schemes', jsonEncode(res));
        return list;
      } catch (_) {}
    }

    final cached = StorageService.getCachedData('schemes');
    if (cached != null) {
      try {
        final decoded = jsonDecode(cached) as List;
        return decoded.map((s) => GovernmentSchemeModel.fromJson(s)).toList();
      } catch (_) {}
    }

    return _sampleSchemes;
  }
}
