import 'package:flutter/foundation.dart';
import '../data/models/crop_price_model.dart';
import '../data/models/crop_transaction_model.dart';
import '../data/repositories/crop_price_repository.dart';
import '../core/services/storage_service.dart';

class CropPriceProvider extends ChangeNotifier {
  final CropPriceRepository _repo = CropPriceRepository();

  List<CropPriceListing> _traderOffers = [];
  List<CropTransactionModel> _actualTransactions = [];
  bool _isLoading = false;
  int _selectedTabIndex = 0; // 0 = Offers, 1 = Actual Transactions

  List<CropPriceListing> get traderOffers => _traderOffers;
  List<CropTransactionModel> get actualTransactions => _actualTransactions;
  bool get isLoading => _isLoading;
  int get selectedTabIndex => _selectedTabIndex;

  CropPriceProvider() {
    loadAllPrices();
  }

  void setSelectedTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  Future<void> loadAllPrices() async {
    _isLoading = true;
    notifyListeners();

    final district = StorageService.getDistrict();
    _traderOffers = await _repo.fetchTraderOffers(district: district);
    _actualTransactions = await _repo.fetchActualTransactions(district: district);

    _isLoading = false;
    notifyListeners();
  }

  /// Post a new 3-tier crop offer as a Trader
  Future<bool> postTraderOffer({
    required String cropNameTa,
    required String cropNameEn,
    required String marketOrVillage,
    required String priceUnit,
    required double grade1Price,
    required double grade2Price,
    required double grade3Price,
    required String notes,
  }) async {
    _isLoading = true;
    notifyListeners();

    final traderId = StorageService.getUserId() ?? 'trader-user';
    final listing = CropPriceListing(
      id: 'offer-${DateTime.now().millisecondsSinceEpoch}',
      traderId: traderId,
      cropId: 'crop-custom-${DateTime.now().millisecondsSinceEpoch}',
      cropNameTa: cropNameTa,
      cropNameEn: cropNameEn,
      district: StorageService.getDistrict(),
      marketOrVillage: marketOrVillage,
      priceUnit: priceUnit,
      grade1Price: grade1Price,
      grade2Price: grade2Price,
      grade3Price: grade3Price,
      notes: notes,
    );

    final success = await _repo.postTraderOffer(listing);
    await loadAllPrices();
    return success;
  }

  /// Record an actual completed transaction
  Future<bool> recordTransaction({
    required String cropName,
    required String qualityGrade,
    required double transactionPrice,
    required String priceUnit,
    required double quantitySold,
    required String marketOrVillage,
    required String source,
  }) async {
    _isLoading = true;
    notifyListeners();

    final userId = StorageService.getUserId() ?? 'farmer-user';
    final tx = CropTransactionModel(
      id: 'tx-${DateTime.now().millisecondsSinceEpoch}',
      cropId: 'crop-${cropName.hashCode}',
      cropName: cropName,
      qualityGrade: qualityGrade,
      transactionPrice: transactionPrice,
      priceUnit: priceUnit,
      quantitySold: quantitySold,
      marketOrVillage: marketOrVillage,
      district: StorageService.getDistrict(),
      transactionDate: DateTime.now(),
      reportedBy: userId,
      source: source,
      isVerified: false, // New reports start as unverified until audited
    );

    final success = await _repo.recordTransaction(tx);
    await loadAllPrices();
    return success;
  }
}
