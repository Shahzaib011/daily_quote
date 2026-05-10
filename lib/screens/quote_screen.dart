// lib/screens/quote_screen.dart
//
// The single screen of the app.
// Responsibilities:
//   • Triggers the first quote fetch on init
//   • Observes QuoteProvider via Consumer<T>
//   • Composes QuoteCard + NewQuoteButton + decorative elements
//   • Is fully responsive (works on phone, tablet, desktop)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/quote_provider.dart';
import '../widgets/quote_card.dart';
import '../widgets/new_quote_button.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the first quote after the first frame so Provider is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuoteProvider>().fetchNewQuote();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;
    // On wide screens (tablet/web) constrain the content width.
    final contentWidth = isWide ? 520.0 : double.infinity;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8), // Warm off-white
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 0 : 24,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Header ──────────────────────────────────────────────
                  _Header(),
                  const SizedBox(height: 40),

                  // ── Quote card — expands to fill available space ────────
                  Expanded(
                    child: Consumer<QuoteProvider>(
                      builder: (context, provider, _) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            QuoteCard(
                              quote: provider.quote,
                              isLoading: provider.isLoading,
                              errorMessage: provider.hasError
                                  ? provider.errorMessage
                                  : null,
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ── CTA Button ───────────────────────────────────────────
                  Consumer<QuoteProvider>(
                    builder: (context, provider, _) {
                      return NewQuoteButton(
                        isLoading: provider.isLoading,
                        onPressed: () =>
                            context.read<QuoteProvider>().fetchNewQuote(),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // ── Footer ───────────────────────────────────────────────
                  _Footer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.format_quote_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Daily Wisdom',
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1C1C1E),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'A thought to carry with you today',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF8E8E93),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

// ─── Footer ───────────────────────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuoteProvider>(
      builder: (context, provider, _) {
        return AnimatedOpacity(
          opacity: provider.status == QuoteStatus.loaded ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 400),
          child: Text(
            'Tap "New Quote" for another spark of wisdom',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFFAEAEB2),
            ),
          ),
        );
      },
    );
  }
}
