// lib/presentation/providers/locale_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    return const Locale('en');
  }

  void setLocale(Locale locale) {
    state = locale;
  }
}
