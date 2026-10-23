import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzhavan360/core/services/storage_service.dart';
import 'package:uzhavan360/data/models/crop_price_model.dart';
import 'package:uzhavan360/data/models/crop_transaction_model.dart';
import 'package:uzhavan360/data/repositories/crop_price_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
  });

  group('Crop Price & Mandatory Separation Tests (Requirement 20)', () {
    test('Trader Offer Quote supports 3-tier quality pricing (Grade 1, 2, 3)', () {
      final offer = CropPriceListing(
        id: 'test-offer-1',
        traderId: 'trader-101',
        cropId: 'crop-paddy-1',
        cropNameTa: 'நெல் (பொன்னி)',
        cropNameEn: 'Paddy (Ponni)',
        district: 'Madurai',
        marketOrVillage: 'வாடிப்பட்டி',
        priceUnit: 'quintal',
        grade1Price: 2450.0,
        grade2Price: 2200.0,
        grade3Price: 1950.0,
      );

      expect(offer.grade1Price, equals(2450.0));
      expect(offer.grade2Price, equals(2200.0));
      expect(offer.grade3Price, equals(1950.0));
      expect(offer.priceUnit, equals('quintal'));
    });

    test('Actual Transaction is strictly separated and supports verification audit', () {
      final tx = CropTransactionModel(
        id: 'tx-101',
        cropId: 'crop-paddy-1',
        cropName: 'நெல் (பொன்னி)',
        qualityGrade: 'grade_1',
        transactionPrice: 2420.0,
        priceUnit: 'quintal',
        quantitySold: 50.0,
        marketOrVillage: 'வாடிப்பட்டி ஒழுங்குமுறை கூடம்',
        district: 'Madurai',
        transactionDate: DateTime(2026, 10, 20),
        source: 'regulated_market',
        isVerified: true,
        verifiedBy: 'officer-vadipatti',
      );

      expect(tx.transactionPrice, equals(2420.0));
      expect(tx.isVerified, isTrue);
      expect(tx.qualityGradeLabelTa, contains('முதல் தரம்'));
      // Distinct type and schema from CropPriceListing
      expect(tx is CropPriceListing, isFalse);
    });

    test('Repository maintains distinct storage for Offers vs Completed Transactions', () async {
      final repo = CropPriceRepository();
      final offers = await repo.fetchTraderOffers();
      final transactions = await repo.fetchActualTransactions();

      expect(offers, isNotEmpty);
      expect(offers.first.grade1Price, isPositive);
      expect(transactions.first.transactionPrice, isPositive);
    });
  });
}
