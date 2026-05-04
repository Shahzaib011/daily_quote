// lib/providers/quote_provider.dart
//
// The single source of truth for UI state.
// Wraps QuoteService and exposes:
//   • quote        — the currently displayed Quote (nullable until first load)
//   • status       — loading / loaded / error
//   • errorMessage — human-readable error string when status == error
//
// The UI never talks to QuoteService directly — it only watches this provider.

import 'package:flutter/foundation.dart';
import '../models/quote.dart';
import '../services/quote_service.dart';

// ─── State enum ──────────────────────────────────────────────────────────────
enum QuoteStatus { initial, loading, loaded, error }

// ─── Provider ────────────────────────────────────────────────────────────────
class QuoteProvider extends ChangeNotifier {
  QuoteProvider({QuoteService? service})
      : _service = service ?? QuoteService();

  final QuoteService _service;

  Quote? _quote;
  QuoteStatus _status = QuoteStatus.initial;
  String _errorMessage = '';

  // ─── Getters ─────────────────────────────────────────────────────────────
  Quote? get quote => _quote;
  QuoteStatus get status => _status;
  String get errorMessage => _errorMessage;

  bool get isLoading => _status == QuoteStatus.loading;
  bool get hasError => _status == QuoteStatus.error;

  // ─── Actions ─────────────────────────────────────────────────────────────

  /// Fetch a new random quote.  
  /// Called on app start (from QuoteScreen.initState) and on button tap.
  Future<void> fetchNewQuote() async {
    // Prevent double-taps during a pending request.
    if (_status == QuoteStatus.loading) return;

    _setStatus(QuoteStatus.loading);

    try {
      final quote = await _service.getRandomQuote();
      _quote = quote;
      _setStatus(QuoteStatus.loaded);
    } on StateError catch (e) {
      _errorMessage = e.message;
      _setStatus(QuoteStatus.error);
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
      _setStatus(QuoteStatus.error);
    }
  }

  // ─── Internal helpers ────────────────────────────────────────────────────
  void _setStatus(QuoteStatus s) {
    _status = s;
    notifyListeners();
  }
}
