import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();
  static bool? mockInternetAvailable;

  static Future<bool> hasInternet() async {
    if (mockInternetAvailable != null) {
      return mockInternetAvailable!;
    }
    try {
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      return results.any((r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet);
    } catch (_) {
      return true; // Fallback to optimistic internet in test/simulated environment
    }
  }

  static Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
