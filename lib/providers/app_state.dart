import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/verification_model.dart';
import '../services/mock_data_service.dart';

/// Global application state
class AppState extends ChangeNotifier {
  // ─── User ─────────────────────────────────────────────────────
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ─── Stats ────────────────────────────────────────────────────
  VerificationStats? _stats;
  VerificationStats? get stats => _stats;

  // ─── Initialization ───────────────────────────────────────────
  Future<void> initialize() async {
    _setLoading(true);
    try {
      // Phase 1: Load mock data
      await Future.delayed(const Duration(milliseconds: 500));
      _currentUser = MockDataService.currentUser;
      _stats = MockDataService.stats;
      _clearError();
    } catch (e) {
      _setError('Failed to load user data: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
