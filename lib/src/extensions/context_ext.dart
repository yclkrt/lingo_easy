import 'package:flutter/material.dart';
import '../widgets/lingo_wrapper.dart';

extension LingoContextExtension on BuildContext {
  /// Returns the translated string for the given [key].
  /// Rebuilds the widget whenever the active locale changes.
  ///
  /// Optionally pass [params] to replace `{placeholder}` values dynamically.
  ///
  /// Example:
  /// ```dart
  /// Text(context.ln('app_title'))
  /// Text(context.ln('welcome', params: {'name': 'Fatih'}))
  /// ```
  String ln(String key, {Map<String, String>? params}) {
    final controller = LingoWrapper.of(this, listen: true);
    return controller.translate(key, params: params);
  }

  /// Changes the active application locale to [newLocale].
  /// Does NOT trigger a rebuild on the calling widget itself.
  ///
  /// Example:
  /// ```dart
  /// context.setLocale('tr');
  /// ```
  void setLocale(String newLocale) {
    final controller = LingoWrapper.of(this, listen: false);
    controller.setLocale(newLocale);
  }

  /// Returns the currently active locale code (e.g. `'en'`, `'tr'`).
  /// Rebuilds the widget when the locale changes.
  String get currentLocale {
    final controller = LingoWrapper.of(this, listen: true);
    return controller.currentLocale;
  }

  /// Returns all supported locale codes defined in [LingoWrapper].
  /// Does NOT trigger a rebuild.
  List<String> get availableLocales {
    final controller = LingoWrapper.of(this, listen: false);
    return controller.availableLocales;
  }

  /// Deprecated: Use [ln] instead.
  ///
  /// `context.tr()` will be removed in v2.0.0.
  @Deprecated('Use context.ln() instead. context.tr() will be removed in v2.0.0.')
  String tr(String key, {Map<String, String>? params}) => ln(key, params: params);
}
