import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Splash screen displayed during app initialization
/// Shows a loading indicator while the app is setting up
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF006064), // Calm Teal primary color
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App icon or logo would go here
              Icon(
                Icons.language,
                size: 80,
                color: Colors.white.withValues(alpha: 0.9),
              ),
              const SizedBox(height: AppTheme.spacing24),
              Text(
                'Language Rally',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withValues(alpha: 0.9),
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: AppTheme.spacing32),
              const SizedBox(height: AppTheme.spacing32),
              // Loading indicator
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.9),
                  ),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),
              Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.7),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


