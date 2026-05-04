// lib/widgets/quote_card.dart
//
// A self-contained card widget that:
//   • Fades + slides in whenever a new quote is passed to it
//   • Displays quote text and author with polished typography
//   • Handles the loading skeleton and error states internally
//
// All animation is triggered by the AnimatedSwitcher key change —
// when [quote] changes, Flutter swaps the child and plays the transition.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/quote.dart';

class QuoteCard extends StatelessWidget {
  const QuoteCard({
    super.key,
    required this.quote,
    required this.isLoading,
    this.errorMessage,
  });

  final Quote? quote;
  final bool isLoading;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        // Combined fade + vertical slide transition.
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.06),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      // The key change is what triggers the AnimatedSwitcher to animate.
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return _LoadingSkeleton(key: const ValueKey('loading'));
    }

    if (errorMessage != null && errorMessage!.isNotEmpty) {
      return _ErrorContent(
        key: const ValueKey('error'),
        message: errorMessage!,
      );
    }

    if (quote == null) {
      return const SizedBox.shrink(key: ValueKey('empty'));
    }

    return _QuoteContent(key: ValueKey(quote!.text), quote: quote!);
  }
}

// ─── Quote content ────────────────────────────────────────────────────────────
class _QuoteContent extends StatelessWidget {
  const _QuoteContent({super.key, required this.quote});
  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Opening quotation mark — decorative, not semantic
          Text(
            '\u201C',
            style: GoogleFonts.playfairDisplay(
              fontSize: 72,
              height: 0.8,
              color: const Color(0xFFD4A96A),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          // Quote body
          Text(
            quote.text,
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              height: 1.65,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1C1C1E),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 28),
          // Divider
          Container(
            width: 40,
            height: 1.5,
            decoration: BoxDecoration(
              color: const Color(0xFFD4A96A),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(height: 20),
          // Author
          Text(
            '— ${quote.author}',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF8E8E93),
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Loading skeleton ─────────────────────────────────────────────────────────
class _LoadingSkeleton extends StatefulWidget {
  const _LoadingSkeleton({super.key});

  @override
  State<_LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<_LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: FadeTransition(
        opacity: _anim,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _shimmerBar(72, 12),
            const SizedBox(height: 24),
            _shimmerBar(double.infinity, 16),
            const SizedBox(height: 10),
            _shimmerBar(double.infinity, 16),
            const SizedBox(height: 10),
            _shimmerBar(200, 16),
            const SizedBox(height: 32),
            _shimmerBar(80, 12),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBar(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5EA),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

// ─── Error state ──────────────────────────────────────────────────────────────
class _ErrorContent extends StatelessWidget {
  const _ErrorContent({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: Color(0xFFFF3B30),
          ),
          const SizedBox(height: 16),
          Text(
            'Oops!',
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF8E8E93),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared card shell ────────────────────────────────────────────────────────
class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Responsive: cap width on large screens
    final horizontalPadding = screenWidth > 600 ? 0.0 : 0.0;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
