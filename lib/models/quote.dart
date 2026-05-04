// lib/models/quote.dart
//
// The core data model for a quote.
// Immutable, with equality support for safe comparisons
// (used to prevent consecutive duplicates).

class Quote {
  final String text;
  final String author;

  const Quote({
    required this.text,
    required this.author,
  });

  // Equality is based on content — two quotes with the same
  // text + author are considered identical.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Quote &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          author == other.author;

  @override
  int get hashCode => text.hashCode ^ author.hashCode;

  @override
  String toString() => 'Quote(author: $author)';
}
