import '../models/adviser_model.dart';

class AdviserRepository {
  final List<AdviserModel> _sampleAdvisers = [
    AdviserModel(
      id: 'adv-1',
      fullName: 'திரு. எஸ். மருதுபாண்டி',
      district: 'Madurai',
      village: 'வாடிப்பட்டி',
      specializationsTa: ['பாரம்பரிய நெல் சாகுபடி', 'இயற்கை பூச்சி மேலாண்மை', 'பஞ்சகாவ்யா தயாரிப்பு'],
      specializationsEn: ['Traditional Paddy Cultivation', 'Organic Pest Management', 'Panchagavya Preparation'],
      experienceYears: 28,
      availableHours: '6:00 PM - 8:00 PM',
      rating: 4.9,
      reviewsCount: 34,
      contactPhone: '+919842155001',
      isVerified: true,
    ),
    AdviserModel(
      id: 'adv-2',
      fullName: 'முனைவர் ஆர். கதிர்வேல்',
      district: 'Coimbatore',
      village: 'பொள்ளாச்சி',
      specializationsTa: ['தென்னை சொட்டுநீர் பாசனம்', 'மண்ணியல் பரிசோதனை', 'நுண்ணூட்ட உரம்'],
      specializationsEn: ['Coconut Drip Irrigation', 'Soil Testing', 'Micronutrient Fertilization'],
      experienceYears: 22,
      availableHours: '5:00 PM - 7:30 PM',
      rating: 4.8,
      reviewsCount: 29,
      contactPhone: '+919842155002',
      isVerified: true,
    ),
    AdviserModel(
      id: 'adv-3',
      fullName: 'திருமதி. மு. மல்லிகா',
      district: 'Erode',
      village: 'கோபிசெட்டிபாளையம்',
      specializationsTa: ['மஞ்சள் பதப்படுத்துதல்', 'நாட்டு மாடு வளர்ப்பு', 'மண்புழு உரம்'],
      specializationsEn: ['Turmeric Processing', 'Native Cow Farming', 'Vermicomposting'],
      experienceYears: 18,
      availableHours: '4:00 PM - 6:30 PM',
      rating: 5.0,
      reviewsCount: 42,
      contactPhone: '+919842155003',
      isVerified: true,
    ),
  ];

  Future<List<AdviserModel>> fetchAdvisers() async {
    return _sampleAdvisers;
  }
}
