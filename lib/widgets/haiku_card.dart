import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_haiku/providers/theme_provider.dart';

class HaikuCard extends StatelessWidget {
  const HaikuCard({super.key});

  final List<Map<String, String>> wisdomQuotes = const [
    {
      "haiku": "Honor God with your wealth,\nFirstfruits given with glad heart,\nStorehouses overflow.",
      "title": "Proverbs 3:9 • Faithful Stewardship"
    },
    {
      "haiku": "Precious treasure in the home,\nSaved by wisdom, spent with care,\nPeace & blessing dwell.",
      "title": "Proverbs 21:20 • Wise Planning"
    },
    {
      "haiku": "Steady savings grow in grace,\nLittle by little wealth abounds,\nDiligence bears fruit.",
      "title": "Proverbs 13:11 • Diligent Growth"
    },
    {
      "haiku": "Commit your works unto the Lord,\nYour plans established step by step,\nConfidence remains.",
      "title": "Proverbs 16:3 • Faithful Foundation"
    },
    {
      "haiku": "Contentment is great gain,\nWalk in faith and grateful heart,\nWealth beyond measure.",
      "title": "1 Timothy 6:6 • Grateful Abundance"
    }
  ];

  @override
  Widget build(BuildContext context) {
    final seed = DateTime.now().day;
    final item = wisdomQuotes[Random(seed).nextInt(wisdomQuotes.length)];
    final themeProvider = Provider.of<ThemeProvider>(context);
    final palette = themeProvider.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background Parchment Image Asset
            Positioned.fill(
              child: Image.asset(
                'assets/images/lotus_parchment_bg.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: isDark ? palette.cardDark : palette.cardLight,
                ),
              ),
            ),
            // Semi transparent overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            palette.cardDark.withOpacity(0.94),
                            palette.cardDark.withOpacity(0.97),
                          ]
                        : [
                            palette.backgroundLight.withOpacity(0.82),
                            palette.backgroundLight.withOpacity(0.88),
                          ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 22),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 1,
                        width: 30,
                        color: const Color(0xFFD4AF37).withOpacity(0.5),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.eco,
                          color: Color(0xFFD4AF37),
                          size: 18,
                        ),
                      ),
                      Container(
                        height: 1,
                        width: 30,
                        color: const Color(0xFFD4AF37).withOpacity(0.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    item["haiku"]!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 17,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      height: 1.6,
                      color: isDark ? const Color(0xFFF5EBE0) : const Color(0xFF3D271D),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item["title"]!.toUpperCase(),
                    style: GoogleFonts.cinzel(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFD4AF37),
                      letterSpacing: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
