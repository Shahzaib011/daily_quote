// lib/services/quote_service.dart
//
// Responsible for:
//   1. Holding the local quote list (easily swappable with an API later)
//   2. Returning a random quote, guaranteed not to be the same as the last one
//   3. Simulating a real async loading delay for realistic UX

import 'dart:math';
import '../models/quote.dart';

class QuoteService {
  // ─── Quote corpus ────────────────────────────────────────────────────────
  // To add more quotes or plug in an API, only this section needs to change.
  static const List<Quote> _quotes = [
    Quote(
      text:
          "The only way to do great work is to love what you do.",
      author: "Steve Jobs",
    ),
    Quote(
      text:
          "In the middle of every difficulty lies opportunity.",
      author: "Albert Einstein",
    ),
    Quote(
      text:
          "It does not matter how slowly you go as long as you do not stop.",
      author: "Confucius",
    ),
    Quote(
      text:
          "Life is what happens when you're busy making other plans.",
      author: "John Lennon",
    ),
    Quote(
      text:
          "The future belongs to those who believe in the beauty of their dreams.",
      author: "Eleanor Roosevelt",
    ),
    Quote(
      text:
          "Strive not to be a success, but rather to be of value.",
      author: "Albert Einstein",
    ),
    Quote(
      text:
          "You miss 100% of the shots you don't take.",
      author: "Wayne Gretzky",
    ),
    Quote(
      text:
          "Whether you think you can or you think you can't, you're right.",
      author: "Henry Ford",
    ),
    Quote(
      text:
          "The two most important days in your life are the day you are born and the day you find out why.",
      author: "Mark Twain",
    ),
    Quote(
      text:
          "Whatever you can do, or dream you can, begin it. Boldness has genius, power, and magic in it.",
      author: "Johann Wolfgang von Goethe",
    ),
    Quote(
      text:
          "The best time to plant a tree was 20 years ago. The second best time is now.",
      author: "Chinese Proverb",
    ),
    Quote(
      text:
          "An unexamined life is not worth living.",
      author: "Socrates",
    ),
    Quote(
      text:
          "Spread love everywhere you go. Let no one ever come to you without leaving happier.",
      author: "Mother Teresa",
    ),
    Quote(
      text:
          "When you reach the end of your rope, tie a knot in it and hang on.",
      author: "Franklin D. Roosevelt",
    ),
    Quote(
      text:
          "Always remember that you are absolutely unique. Just like everyone else.",
      author: "Margaret Mead",
    ),
    Quote(
      text:
          "Do not go where the path may lead, go instead where there is no path and leave a trail.",
      author: "Ralph Waldo Emerson",
    ),
    Quote(
      text:
          "You will face many defeats in life, but never let yourself be defeated.",
      author: "Maya Angelou",
    ),
    Quote(
      text:
          "In the end, it's not the years in your life that count. It's the life in your years.",
      author: "Abraham Lincoln",
    ),
    Quote(
      text:
          "Never let the fear of striking out keep you from playing the game.",
      author: "Babe Ruth",
    ),
    Quote(
      text:
          "Life is either a daring adventure or nothing at all.",
      author: "Helen Keller",
    ),
  ];

  // ─── State ────────────────────────────────────────────────────────────────
  final Random _random = Random();
  Quote? _lastQuote;

  // ─── Public API ───────────────────────────────────────────────────────────

  /// Returns a random quote after an artificial delay.
  ///
  /// Throws [StateError] if the quote list is empty.
  /// Never returns the same quote twice in a row (unless list has 1 item).
  Future<Quote> getRandomQuote() async {
    // Guard: empty list
    if (_quotes.isEmpty) {
      throw StateError('Quote list is empty.');
    }

    // Simulate network / disk latency for realistic loading UX.
    // Replace this with an actual HTTP call when wiring up an API.
    await Future.delayed(const Duration(milliseconds: 600));

    // Pick a quote different from the last one shown.
    Quote candidate;
    do {
      candidate = _quotes[_random.nextInt(_quotes.length)];
    } while (_quotes.length > 1 && candidate == _lastQuote);

    _lastQuote = candidate;
    return candidate;
  }

  /// Total number of available quotes — useful for unit tests / stats UI.
  int get quoteCount => _quotes.length;
}
