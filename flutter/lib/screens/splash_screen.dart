import 'package:flutter/material.dart';

/// Screen 1: Splash Screen demonstrating Icons, Column, TextStyle, and ElevatedButton
class SplashScreen extends StatelessWidget {
  final VoidCallback onGetStarted;

  const SplashScreen({Key? key, required this.onGetStarted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryTeal = Color(0xFF0F766E);

    return Scaffold(
      backgroundColor: const Color(0xFFF0FDFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Logo container using Flutter Icons and Container decoration
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryTeal,
                ),
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.search, size: 52, color: Colors.white),
                    Positioned(
                      top: 18,
                      right: 18,
                      child: Icon(Icons.location_on,
                          size: 24, color: Color(0xFFFCD34D)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // App Name
              const Text(
                'FindIt',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF115E59),
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 8),

              // Tagline
              const Text(
                'Lost something? Find it here.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
                textAlign: TextAlign.Center,
              ),

              const SizedBox(height: 12),

              const Text(
                'Connect with university students to report, track, and recover misplaced campus items quickly and safely.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4B5563),
                  height: 1.4,
                ),
                textAlign: TextAlign.Center,
              ),

              const Spacer(),

              // Get Started Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: onGetStarted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryTeal,
                    foregroundColor: Colors.white,
                    shape: RoundedCornerShape(14),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
