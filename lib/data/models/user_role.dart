import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';

enum AppRole {
  worker,
  owner,
  trader,
  workerLandowner,
  landownerTrader,
  panchayatOfficial,
}

extension AppRoleExtension on AppRole {
  String get code {
    switch (this) {
      case AppRole.worker:
        return 'worker';
      case AppRole.owner:
        return 'owner';
      case AppRole.workerLandowner:
        return 'worker_landowner';
      case AppRole.landownerTrader:
        return 'landowner_trader';
      case AppRole.trader:
        return 'trader';
      case AppRole.panchayatOfficial:
        return 'panchayat_official';
    }
  }

  String get titleTa {
    switch (this) {
      case AppRole.worker:
        return 'விவசாயத் தொழிலாளி';
      case AppRole.owner:
        return 'நில உரிமையாளர்';
      case AppRole.workerLandowner:
        return 'தொழிலாளி + நில உரிமையாளர்';
      case AppRole.landownerTrader:
        return 'நில உரிமையாளர் + வியாபாரி';
      case AppRole.trader:
        return 'விளைபொருள் வியாபாரி';
      case AppRole.panchayatOfficial:
        return 'பஞ்சாயத்து அலுவலக அதிகாரி';
    }
  }

  String get titleEn {
    switch (this) {
      case AppRole.worker:
        return 'Agricultural Worker';
      case AppRole.owner:
        return 'Landowner';
      case AppRole.workerLandowner:
        return 'Worker + Landowner';
      case AppRole.landownerTrader:
        return 'Landowner + Trader';
      case AppRole.trader:
        return 'Crop Trader';
      case AppRole.panchayatOfficial:
        return 'Panchayat Office Official';
    }
  }

  String get descTa {
    switch (this) {
      case AppRole.worker:
        return 'தினசரி பண்ணை வேலை மற்றும் கூலி வாய்ப்புகளைக் கண்டறியலாம்';
      case AppRole.owner:
        return 'வேலைகளுக்கு ஆட்கள் சேர்க்கலாம் மற்றும் பயிர் விலை நிலவரங்களைப் பார்க்கலாம்';
      case AppRole.workerLandowner:
        return 'வேலைகளுக்கு ஆட்கள் சேர்க்கலாம் மற்றும் வேலைகளில் ஈடுபடலாம்';
      case AppRole.landownerTrader:
        return 'சாகுபடி நிலத்தை நிர்வகிக்கலாம் மற்றும் விளைபொருள் விலை நிர்ணயிக்கலாம்';
      case AppRole.trader:
        return 'விளைபொருட்களுக்கு 3 தரநிலைகளில் தினசரி விலை நிலவரம் பதிவிடலாம்';
      case AppRole.panchayatOfficial:
        return 'கிராம சபை, அரசு நிதி மற்றும் மக்கள் நல அறிவிப்புகளை வெளியிடலாம் (சரிபார்ப்பு தேவை)';
    }
  }

  String get descEn {
    switch (this) {
      case AppRole.worker:
        return 'Find daily agricultural wage labor and harvesting work';
      case AppRole.owner:
        return 'Post labor requirements and track crop market prices';
      case AppRole.workerLandowner:
        return 'Post labor requirements and engage in agricultural operations';
      case AppRole.landownerTrader:
        return 'Manage farmland and publish market crop offerings';
      case AppRole.trader:
        return 'Publish daily 3-tier quality crop prices in local markets';
      case AppRole.panchayatOfficial:
        return 'Publish Gram Sabha meetings, public fund accounts and alerts';
    }
  }

  String localizedTitle(BuildContext context) {
    switch (this) {
      case AppRole.worker:
        return context.tr('role_worker');
      case AppRole.owner:
      case AppRole.workerLandowner:
      case AppRole.landownerTrader:
        return context.tr('role_owner');
      case AppRole.trader:
        return context.tr('role_trader');
      case AppRole.panchayatOfficial:
        return context.tr('role_official');
    }
  }

  String localizedDesc(BuildContext context) {
    switch (this) {
      case AppRole.worker:
        return context.tr('role_worker_desc');
      case AppRole.owner:
      case AppRole.workerLandowner:
      case AppRole.landownerTrader:
        return context.tr('role_owner_desc');
      case AppRole.trader:
        return context.tr('role_trader_desc');
      case AppRole.panchayatOfficial:
        return context.tr('role_official_desc');
    }
  }

  IconData get icon {
    switch (this) {
      case AppRole.worker:
        return Icons.agriculture;
      case AppRole.owner:
      case AppRole.workerLandowner:
        return Icons.nature_people;
      case AppRole.landownerTrader:
        return Icons.storefront;
      case AppRole.trader:
        return Icons.shopping_basket;
      case AppRole.panchayatOfficial:
        return Icons.account_balance;
    }
  }

  static AppRole fromCode(String code) {
    switch (code) {
      case 'owner':
      case 'worker_landowner':
      case 'landowner_trader':
        return AppRole.owner;
      case 'trader':
        return AppRole.trader;
      case 'panchayat_official':
        return AppRole.panchayatOfficial;
      case 'worker':
      default:
        return AppRole.worker;
    }
  }
}
