import 'package:flutter/foundation.dart';
import '../data/models/government_scheme_model.dart';
import '../data/repositories/scheme_repository.dart';

class SchemeProvider extends ChangeNotifier {
  final SchemeRepository _repo = SchemeRepository();

  List<GovernmentSchemeModel> _schemes = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<GovernmentSchemeModel> get schemes {
    if (_searchQuery.isEmpty) return _schemes;
    return _schemes.where((s) =>
        s.titleTa.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        s.titleEn.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        s.department.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  bool get isLoading => _isLoading;

  SchemeProvider() {
    loadSchemes();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadSchemes() async {
    _isLoading = true;
    notifyListeners();
    _schemes = await _repo.fetchSchemes();
    _isLoading = false;
    notifyListeners();
  }
}
