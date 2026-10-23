import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/supabase_config.dart';
import '../../core/services/storage_service.dart';
import '../models/crop_price_model.dart';
import '../models/crop_transaction_model.dart';

class CropPriceRepository {
  // Sample Trader Offer Quotes (clearly identified as trader quotes)
  final List<CropPriceListing> _sampleOfferListings = [
    CropPriceListing(
      id: 'offer-1',
      traderId: 'trader-madurai-1',
      cropId: 'crop-paddy-1',
      cropNameTa: 'நெல் (பொன்னி)',
      cropNameEn: 'Paddy (Ponni)',
      district: 'Madurai',
      marketOrVillage: 'வாடிப்பட்டி ஒழுங்குமுறை விற்பனைக்கூடம்',
      priceUnit: 'quintal',
      grade1Price: 2450.0,
      grade2Price: 2200.0,
      grade3Price: 1950.0,
      notes: 'ஈரப்பதம் 17% க்குள் இருக்க வேண்டும். நேரடி எடை.',
    ),
    CropPriceListing(
      id: 'offer-2',
      traderId: 'trader-erode-1',
      cropId: 'crop-turmeric-1',
      cropNameTa: 'மஞ்சள் (விரலி)',
      cropNameEn: 'Turmeric (Finger)',
      district: 'Erode',
      marketOrVillage: 'பெருந்துறை ஒழுங்குமுறை கூடம்',
      priceUnit: 'quintal',
      grade1Price: 14800.0,
      grade2Price: 13200.0,
      grade3Price: 11500.0,
      notes: 'நல்ல மஞ்சள் நிறம், உலர்ந்த விரலி மஞ்சள்.',
    ),
    CropPriceListing(
      id: 'offer-3',
      traderId: 'trader-thanjavur-1',
      cropId: 'crop-blackgram-1',
      cropNameTa: 'உளுந்து (கருப்பு)',
      cropNameEn: 'Black Gram',
      district: 'Thanjavur',
      marketOrVillage: 'கும்பகோணம் மண்டி',
      priceUnit: 'quintal',
      grade1Price: 8900.0,
      grade2Price: 8200.0,
      grade3Price: 7400.0,
      notes: 'சுத்தப்படுத்தப்பட்ட உளுந்து.',
    ),
    CropPriceListing(
      id: 'offer-4',
      traderId: 'trader-madurai-2',
      cropId: 'crop-tomato-1',
      cropNameTa: 'தக்காளி',
      cropNameEn: 'Tomato',
      district: 'Madurai',
      marketOrVillage: 'பரவை மார்க்கெட்',
      priceUnit: 'kg',
      grade1Price: 38.0,
      grade2Price: 28.0,
      grade3Price: 18.0,
      notes: 'நாட்டுத் தக்காளி மற்றும் ஆப்பிள் தக்காளி.',
    ),
  ];

  // Sample Actual Completed Transactions (Separate from offers!)
  final List<CropTransactionModel> _sampleTransactions = [
    CropTransactionModel(
      id: 'tx-201',
      cropId: 'crop-paddy-1',
      cropName: 'நெல் (பொன்னி)',
      qualityGrade: 'grade_1',
      transactionPrice: 2420.0,
      priceUnit: 'quintal',
      quantitySold: 45.0,
      marketOrVillage: 'வாடிப்பட்டி ஒழுங்குமுறை கூடம்',
      district: 'Madurai',
      transactionDate: DateTime.now().subtract(const Duration(days: 1)),
      source: 'regulated_market',
      isVerified: true,
      verifiedBy: 'officer-vadipatti-market',
    ),
    CropTransactionModel(
      id: 'tx-202',
      cropId: 'crop-paddy-1',
      cropName: 'நெல் (பொன்னி)',
      qualityGrade: 'grade_2',
      transactionPrice: 2180.0,
      priceUnit: 'quintal',
      quantitySold: 30.0,
      marketOrVillage: 'வாடிப்பட்டி ஒழுங்குமுறை கூடம்',
      district: 'Madurai',
      transactionDate: DateTime.now().subtract(const Duration(days: 1)),
      source: 'regulated_market',
      isVerified: true,
      verifiedBy: 'officer-vadipatti-market',
    ),
    CropTransactionModel(
      id: 'tx-203',
      cropId: 'crop-turmeric-1',
      cropName: 'மஞ்சள் (விரலி)',
      qualityGrade: 'grade_1',
      transactionPrice: 14500.0,
      priceUnit: 'quintal',
      quantitySold: 22.0,
      marketOrVillage: 'பெருந்துறை கூடம்',
      district: 'Erode',
      transactionDate: DateTime.now().subtract(const Duration(days: 2)),
      source: 'regulated_market',
      isVerified: true,
      verifiedBy: 'officer-erode-market',
    ),
  ];

  /// Fetch Trader Offer Quotes (3-tier quality pricing)
  Future<List<CropPriceListing>> fetchTraderOffers({String? district}) async {
    if (SupabaseConfig.isConfigured) {
      try {
        var query = Supabase.instance.client
            .from('crop_price_listings')
            .select()
            .eq('is_active', true);

        if (district != null && district.isNotEmpty) {
          query = query.eq('district', district);
        }

        final res = await query.order('created_at', ascending: false);
        final list = (res as List).map((p) => CropPriceListing.fromJson(p)).toList();

        await StorageService.cacheData('trader_offers', jsonEncode(res));
        return list;
      } catch (_) {}
    }

    // Try offline cache or sample
    final cached = StorageService.getCachedData('trader_offers');
    if (cached != null) {
      try {
        final decoded = jsonDecode(cached) as List;
        return decoded.map((p) => CropPriceListing.fromJson(p)).toList();
      } catch (_) {}
    }

    return _sampleOfferListings;
  }

  /// Post a new Trader Offer Price (3 quality levels)
  Future<bool> postTraderOffer(CropPriceListing listing) async {
    _sampleOfferListings.insert(0, listing);
    if (SupabaseConfig.isConfigured) {
      try {
        await Supabase.instance.client
            .from('crop_price_listings')
            .insert(listing.toJson());
        return true;
      } catch (_) {
        return false;
      }
    }
    return true;
  }

  /// Fetch Actual Completed Sale Transactions (Mandatory Separation!)
  Future<List<CropTransactionModel>> fetchActualTransactions({String? district}) async {
    if (SupabaseConfig.isConfigured) {
      try {
        var query = Supabase.instance.client
            .from('crop_transactions')
            .select();

        if (district != null && district.isNotEmpty) {
          query = query.eq('district', district);
        }

        final res = await query.order('transaction_date', ascending: false);
        final list = (res as List).map((t) => CropTransactionModel.fromJson(t)).toList();

        await StorageService.cacheData('actual_transactions', jsonEncode(res));
        return list;
      } catch (_) {}
    }

    final cached = StorageService.getCachedData('actual_transactions');
    if (cached != null) {
      try {
        final decoded = jsonDecode(cached) as List;
        return decoded.map((t) => CropTransactionModel.fromJson(t)).toList();
      } catch (_) {}
    }

    return _sampleTransactions;
  }

  /// Record an actual completed transaction
  Future<bool> recordTransaction(CropTransactionModel tx) async {
    _sampleTransactions.insert(0, tx);
    if (SupabaseConfig.isConfigured) {
      try {
        await Supabase.instance.client
            .from('crop_transactions')
            .insert(tx.toJson());
        return true;
      } catch (_) {
        return false;
      }
    }
    return true;
  }
}
