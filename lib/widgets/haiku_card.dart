import 'package:flutter/material.dart';
import 'dart:math';

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
    
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.05),
            Theme.of(context).primaryColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.amber, size: 20),
          const SizedBox(height: 8),
          Text(
            haiku,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              height: 1.5,
              fontFamily: 'serif',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "- Daily Finance Haiku",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
