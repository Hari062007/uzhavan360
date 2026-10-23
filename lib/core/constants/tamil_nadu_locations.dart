class LocationHierarchy {
  final String district;
  final String districtTa;
  final List<TalukData> taluks;

  const LocationHierarchy({
    required this.district,
    required this.districtTa,
    required this.taluks,
  });
}

class TalukData {
  final String taluk;
  final String talukTa;
  final List<VillageData> villages;

  const TalukData({
    required this.taluk,
    required this.talukTa,
    required this.villages,
  });
}

class VillageData {
  final String name;
  final String nameTa;
  final String pincode;

  const VillageData({
    required this.name,
    required this.nameTa,
    required this.pincode,
  });
}

class TamilNaduLocations {
  static const List<LocationHierarchy> data = [
    LocationHierarchy(
      district: 'Madurai',
      districtTa: 'மதுரை',
      taluks: [
        TalukData(
          taluk: 'Vadipatti',
          talukTa: 'வாடிப்பட்டி',
          villages: [
            VillageData(name: 'Alangottaram', nameTa: 'ஆலங்கொட்டாரம்', pincode: '625218'),
            VillageData(name: 'Kullapuram', nameTa: 'குள்ளபுரம்', pincode: '625218'),
            VillageData(name: 'Katchakatti', nameTa: 'கச்சைகட்டி', pincode: '625218'),
            VillageData(name: 'Melakkal', nameTa: 'மேலக்கால்', pincode: '625234'),
          ],
        ),
        TalukData(
          taluk: 'Melur',
          talukTa: 'மேலூர்',
          villages: [
            VillageData(name: 'Kottampatti', nameTa: 'கொட்டாம்பட்டி', pincode: '625103'),
            VillageData(name: 'Vellalore', nameTa: 'வெள்ளலூர்', pincode: '625109'),
            VillageData(name: 'Navinipatti', nameTa: 'நவினிப்பட்டி', pincode: '625106'),
          ],
        ),
        TalukData(
          taluk: 'Usilampatti',
          talukTa: 'உசிலம்பட்டி',
          villages: [
            VillageData(name: 'Sedapatti', nameTa: 'சேடபட்டி', pincode: '625527'),
            VillageData(name: 'Uthappanaickanur', nameTa: 'உத்தப்பநாயக்கனூர்', pincode: '625537'),
          ],
        ),
      ],
    ),
    LocationHierarchy(
      district: 'Thanjavur',
      districtTa: 'தஞ்சாவூர்',
      taluks: [
        TalukData(
          taluk: 'Papanasam',
          talukTa: 'பாபநாசம்',
          villages: [
            VillageData(name: 'Vazhuthur', nameTa: 'வழுத்தூர்', pincode: '614210'),
            VillageData(name: 'Ayyampettai', nameTa: 'அய்யம்பேட்டை', pincode: '614201'),
            VillageData(name: 'Gopalasamudram', nameTa: 'கோபாலசமுத்திரம்', pincode: '614205'),
          ],
        ),
        TalukData(
          taluk: 'Kumbakonam',
          talukTa: 'கும்பகோணம்',
          villages: [
            VillageData(name: 'Darasuram', nameTa: 'தாராசுரம்', pincode: '612702'),
            VillageData(name: 'Swamimalai', nameTa: 'சுவாமிமலை', pincode: '612302'),
            VillageData(name: 'Patteswaram', nameTa: 'பட்டீஸ்வரம்', pincode: '612703'),
          ],
        ),
        TalukData(
          taluk: 'Orathanadu',
          talukTa: 'ஒரத்தநாடு',
          villages: [
            VillageData(name: 'Thekkur', nameTa: 'தெக்கூர்', pincode: '614625'),
            VillageData(name: 'Kannanthankudi', nameTa: 'கண்ணந்தங்குடி', pincode: '614625'),
          ],
        ),
      ],
    ),
    LocationHierarchy(
      district: 'Coimbatore',
      districtTa: 'கோயம்புத்தூர்',
      taluks: [
        TalukData(
          taluk: 'Pollachi',
          talukTa: 'பொள்ளாச்சி',
          villages: [
            VillageData(name: 'Anaimalai', nameTa: 'ஆனைமலை', pincode: '642104'),
            VillageData(name: 'Kottur', nameTa: 'கோட்டூர்', pincode: '642114'),
            VillageData(name: 'Kinathukadavu', nameTa: 'கிணத்துக்கடவு', pincode: '642109'),
          ],
        ),
      ],
    ),
    LocationHierarchy(
      district: 'Erode',
      districtTa: 'ஈரோடு',
      taluks: [
        TalukData(
          taluk: 'Gobichettipalayam',
          talukTa: 'கோபிசெட்டிபாளையம்',
          villages: [
            VillageData(name: 'Kodiveri', nameTa: 'கொடிவேரி', pincode: '638454'),
            VillageData(name: 'Nambiyur', nameTa: 'நம்பியூர்', pincode: '638458'),
            VillageData(name: 'Kugalur', nameTa: 'கூகலூர்', pincode: '638313'),
          ],
        ),
      ],
    ),
  ];
}
