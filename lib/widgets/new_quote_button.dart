// lib/widgets/new_quote_button.dart
//
// A custom button that:
//   • Shows a spinner while loading (prevents double-tap)
//   • Has a subtle press-scale animation via GestureDetector + AnimatedScale
//   • Is fully accessible (Semantics label)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class NewQuoteButton extends StatefulWidget {
  const NewQuoteButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
  });

  final VoidCallback onPressed;
  final bool isLoading;

  @override
  State<NewQuoteButton> createState() => _NewQuoteButtonState();
}

class _NewQuoteButtonState extends State<NewQuoteButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.96);
  void _onTapUp(_) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Get a new quote',
      button: true,
      child: GestureDetector(
        onTapDown: widget.isLoading ? null : _onTapDown,
        onTapUp: widget.isLoading ? null : _onTapUp,
        onTapCancel: widget.isLoading ? null : _onTapCancel,
        onTap: widget.isLoading
            ? null
            : () {
                HapticFeedback.lightImpact();
                widget.onPressed();
              },
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              color: widget.isLoading
                  ? const Color(0xFF8E8E93)
                  : const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(16),
              boxShadow: widget.isLoading
                  ? []
                  : [
                      BoxShadow(
                        color: const Color(0xFF1C1C1E).withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: widget.isLoading
                      ? const SizedBox(
                          key: ValueKey('spinner'),
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(
                          key: ValueKey('icon'),
                          Icons.auto_awesome_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.isLoading ? 'Loading...' : 'New Quote',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
