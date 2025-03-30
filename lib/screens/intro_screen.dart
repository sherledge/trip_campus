import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/shared_prefs_provider.dart';
import 'home_screen.dart';

class IntroScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> _completeIntro() async {
      await ref.read(sharedPrefsProvider).setSeenIntro(true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with Faded Color and Subtle Blur
          Image.asset(
            "assets/images/background.png", // Replace with your image
            fit: BoxFit.cover,
            color: Color(0xFF052937).withOpacity(0.6), // Faded color overlay
            colorBlendMode: BlendMode.darken,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Main Content with Refined Styling
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 32),
                  // Title (TRIP CAMPUS) with Refined Typography
                  Text(
                    "TRIP CAMPUS",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'AmaticSC',
                      fontSize: 66,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Subtitle with Improved Readability
                  Text(
                    "Discover unforgettable adventures and connect with fellow travelers.",
                    textAlign: TextAlign.center,
                    style: TextStyle(

                      fontFamily:
                      'JosefinSans' ,
                      fontSize: 26,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 48),
                  // Join the Adventure Button with Modern Design
                  Container(
                    decoration: BoxDecoration(
                      border:  Border.all(color: Colors.white, width: 2
                      ),
                    ),
                    child: Container( // Wrap ElevatedButton in a Container for custom styling
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black.withAlpha(128),width: 10 // Outer border
                        )
                      ),
                      child: ElevatedButton(
                        onPressed: _completeIntro,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          child: Text(
                            "JOIN THE ADVENTURE", // Match the image text
                            style: TextStyle(
                               fontFamily: 'AmaticSC',
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF315C68),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, // Square corners
                          ),
                          elevation: 0, // Remove default elevation
                        ).copyWith(
                          side: MaterialStateProperty.all(BorderSide(color: Colors.white, width: 3)), // Inner white border
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}