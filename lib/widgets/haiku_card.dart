import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_haiku/providers/theme_provider.dart';
import 'glass_container.dart';

class HaikuCard extends StatelessWidget {
  const HaikuCard({super.key});

  final List<String> haikus = const [
    "Money flows like rain,\nSpent on coffee and on bread,\nWallet is empty.",
    "Gold coins in the sun,\nSaved for winter's icy breath,\nFuture is secure.",
    "Click the button now,\nTransaction saved in the cloud,\nPeace in mind today.",
    "Budget well today,\nFreedom grows like summer trees,\nRichness is within.",
    "Flowing like a stream,\nIncome meets the expense sea,\nBalance is the key."
  ];

  @override
  Widget build(BuildContext context) {
    final seed = DateTime.now().day;
    final haiku = haikus[Random(seed).nextInt(haikus.length)];
    final themeProvider = Provider.of<ThemeProvider>(context);
    final palette = themeProvider.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassContainer(
      color: palette.primary.withOpacity(0.5),
      blur: 15,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: palette.primary.withOpacity(isDark ? 0.8 : 0.6),
            size: 28,
          ),
          const SizedBox(height: 12),
          Text(
            haiku,
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              height: 1.6,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            width: 40,
            color: palette.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 12),
          Text(
            "Daily Reflection",
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white54 : Colors.black45,
              letterSpacing: 1.2,
              textBaseline: TextBaseline.alphabetic,
            ).copyWith(height: 1),
          ),
        ],
      ),
    );
  }
}
