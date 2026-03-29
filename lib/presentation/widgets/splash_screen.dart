import 'package:flutter/material.dart';
import '../../../core/services/app_initialization_service.dart';
import '../../../core/theme/app_theme.dart';

/// Splash screen displayed during app initialization.
/// When seed packages are being imported for the first time it shows a
/// real-time progress bar so the user knows the app is busy.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SeedingProgress _progress;

  @override
  void initState() {
    super.initState();
    _progress = AppInitializationService.seedingProgress.value;
    AppInitializationService.seedingProgress.addListener(_onProgress);
  }

  @override
  void dispose() {
    AppInitializationService.seedingProgress.removeListener(_onProgress);
    super.dispose();
  }

  void _onProgress() {
    if (mounted) {
      setState(() {
        _progress = AppInitializationService.seedingProgress.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSeeding = _progress.isActive && _progress.total > 0;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF006064), // Calm Teal primary color
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App icon
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/app_icons/language_rally_race.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
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

              // ── Progress area ─────────────────────────────────────────────
              if (isSeeding) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Column(
                    children: [
                      // Determinate progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _progress.fraction,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withValues(alpha: 0.9),
                          ),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing16),
                      Text(
                        'Setting up packages: '
                        '${_progress.current} / ${_progress.total}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.8),
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      Text(
                        'This only happens once.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.55),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Indeterminate spinner for the fast database-init phase
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
                  'Loading…',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.7),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

