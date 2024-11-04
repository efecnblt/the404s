// lib/screens/premium_ad_overlay.dart
import 'package:flutter/material.dart';

class PremiumAdOverlay extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onUpgrade;

  const PremiumAdOverlay({
    super.key,
    required this.onClose,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen size to adjust paddings and sizes accordingly
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black54, // Semi-transparent background
      body: Stack(
        children: [
          // Main content
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.all(16),
              width: screenSize.width * 0.9,
              decoration: BoxDecoration(
                color: Color(0xff6263EA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Wrap content vertically
                  children: [
                    Text(
                      'Upgrade Now!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    // List of premium advantages
                    Column(
                      children: [
                        AdvantageItem(text: 'Access all courses'),
                        AdvantageItem(text: 'Download videos for offline use'),
                        AdvantageItem(text: 'Ad-free experience'),
                        AdvantageItem(text: 'Exclusive premium content'),
                        AdvantageItem(text: 'Priority support'),
                      ],
                    ),
                    SizedBox(height: 24),
                    // Subscribe button
                    ElevatedButton(
                      onPressed: onUpgrade,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        // Customize as needed
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Subscribe',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff6263EA),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: onClose,
            ),
          ),
        ],
      ),
    );
  }
}

class AdvantageItem extends StatelessWidget {
  final String text;

  const AdvantageItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 28,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
