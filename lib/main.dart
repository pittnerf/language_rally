// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:language_rally/l10n/app_localizations.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/services/app_initialization_service.dart';
import 'data/database_helper.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/onboarding/onboarding_screen.dart';
import 'presentation/providers/locale_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/app_settings_provider.dart';
import 'presentation/providers/store_provider.dart';
import 'presentation/widgets/splash_screen.dart';
import '../../core/utils/debug_print.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';
import 'core/services/iap_service.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Configure system UI overlay style for edge-to-edge
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  // Initialize database factory for desktop platforms
  DatabaseHelper.initializeDatabaseFactory();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Activate App Check so Firebase services (Auth, Firestore, Storage) accept
  // requests from this app.  Play Integrity is used on Android (production),
  // debug provider on all other platforms / debug builds.
  await _initAppCheck();

  // Sign in anonymously so Firebase Storage and Firestore rules can
  // restrict access to authenticated users.
  await _signInAnonymously();

  await IAPService.instance.initialise();

  runApp(const ProviderScope(child: LanguageRallyApp()));
}

/// Activates Firebase App Check.
///
/// - Android release builds → Play Integrity (attestation by Google Play).
/// - Everywhere else (debug / iOS / web) → debug provider so the app can
///   still reach Firebase services during development without a real device.
Future<void> _initAppCheck() async {
  // Firebase App Check plugin methods are not implemented on desktop.
  if (_isDesktopPlatform()) {
    logDebug('ℹ️ Firebase App Check skipped on desktop platform');
    return;
  }

  try {
    await FirebaseAppCheck.instance.activate(
      // TODO: switch to AndroidProvider.playIntegrity once the app is live on
      // Google Play.  For now the debug provider lets the app reach Firebase
      // without Play attestation (add the printed debug token in the Firebase
      // Console under App Check → your app → Debug tokens).
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
    );
    logDebug('✓ Firebase App Check activated');
  } catch (e) {
    logDebug('⚠️ Firebase App Check activation failed — $e');
  }
}

bool _isDesktopPlatform() {
  if (kIsWeb) return false;
  return defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS;
}

/// Signs in anonymously to Firebase so that Storage and Firestore security
/// rules can require authentication without forcing the user to log in.
Future<void> _signInAnonymously() async {
  try {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      await auth.signInAnonymously();
    }
    logDebug('✓ Firebase: signed in anonymously (uid=${auth.currentUser?.uid})');
  } catch (e) {
    logDebug('⚠️ Firebase: anonymous sign-in failed — $e');
  }
}

class LanguageRallyApp extends ConsumerStatefulWidget {
  const LanguageRallyApp({super.key});

  @override
  ConsumerState<LanguageRallyApp> createState() => _LanguageRallyAppState();
}

class _LanguageRallyAppState extends ConsumerState<LanguageRallyApp>
    with WidgetsBindingObserver {
  bool _isInitialized = false;
  bool _needsOnboarding = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        // App came back to foreground - reinitialize if needed
        logDebug('App resumed - forcing frame render and refreshing providers');
        // Explicitly request a new frame from the Flutter engine.
        // This is necessary to recover from Samsung Freezess (or any OS-level
        // process suspension) where the rendering pipeline stalls after the
        // app is unfrozen and the surface is recreated, but Flutter never
        // renders — causing a permanent blank screen.
        SchedulerBinding.instance.scheduleFrame();
        _checkAndReinitialize();
        // Force refresh providers to ensure fresh data
        if (mounted) {
          // Refresh settings without blanking them first – calling
          // ref.invalidate() would immediately reset the state to the
          // empty default (no API keys) and only restore them after the
          // async SharedPreferences load completes, creating a window where
          // the keys appear missing.
          ref.read(appSettingsProvider.notifier).refreshFromStorage();
          // Locale and theme providers can be fully invalidated safely
          // because they have no critical "missing key" problem.
          ref.invalidate(localeProvider);
          ref.invalidate(themeProvider);
          _resumePendingStoreDownloads();
        }
        break;
      case AppLifecycleState.paused:
        // App going to background
        logDebug('App paused');
        break;
      case AppLifecycleState.inactive:
        // App is inactive (e.g., phone call)
        logDebug('App inactive');
        break;
      case AppLifecycleState.detached:
        // App is detached
        logDebug('App detached');
        break;
      case AppLifecycleState.hidden:
        // App is hidden
        logDebug('App hidden');
        break;
    }
  }

  Future<void> _checkAndReinitialize() async {
    // Check if database connection is still valid
    try {
      final db = await DatabaseHelper.instance.database;
      // Try a simple query to verify connection
      await db.rawQuery('SELECT 1');
      logDebug('Database connection is healthy');
    } catch (e) {
      logDebug('Database connection issue detected: $e');
      // Reset the static initialization flag so _initializeApp() performs a
      // full re-init instead of returning immediately (the flag stays true
      // across a Freezess/unfreeze cycle since the process is not killed).
      AppInitializationService.reset();
      await _initializeApp();
    }
  }

  Future<void> _initializeApp() async {
    // Perform heavy initialization tasks
    final success = await AppInitializationService.initialize();

    if (success) {
      await _resumePendingStoreDownloads();
    }

    if (mounted) {
      setState(() {
        _isInitialized = success;
        _needsOnboarding = AppInitializationService.needsOnboarding;
      });
    }
  }

  Future<void> _resumePendingStoreDownloads() async {
    await ref.read(storeCatalogProvider.notifier).resumePendingDownloads();
  }

  @override
  Widget build(BuildContext context) {
    // Show splash screen during initialization
    if (!_isInitialized) {
      return const SplashScreen();
    }

    final themeConfig = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    // Select theme based on configuration
    ThemeData lightTheme;
    ThemeData darkTheme;

    switch (themeConfig.themeOption) {
      case AppThemeOption.calmTeal:
        lightTheme = AppTheme.lightTheme;
        darkTheme = AppTheme.darkTheme;
      case AppThemeOption.oceanBlue:
        lightTheme = AppTheme.oceanLightTheme;
        darkTheme = AppTheme.oceanDarkTheme;
      case AppThemeOption.forestGreen:
        lightTheme = AppTheme.forestLightTheme;
        darkTheme = AppTheme.forestDarkTheme;
      case AppThemeOption.sunsetOrange:
        lightTheme = AppTheme.sunsetLightTheme;
        darkTheme = AppTheme.sunsetDarkTheme;
      case AppThemeOption.purpleDreams:
        lightTheme = AppTheme.purpleLightTheme;
        darkTheme = AppTheme.purpleDarkTheme;
    }

    return MaterialApp(
      title: 'Language Rally v1.0.0',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeConfig.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // Ensure app always starts at home when restored
      initialRoute: '/',
      routes: {
        '/': (context) => _needsOnboarding
            ? OnboardingScreen(
                onComplete: () {
                  setState(() => _needsOnboarding = false);
                },
              )
            : const HomePage(),
      },
    );
  }
}
