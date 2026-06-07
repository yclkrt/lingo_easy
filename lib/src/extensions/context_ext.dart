import 'package:flutter/material.dart';
import '../widgets/lingo_wrapper.dart';

extension LingoContextExtension on BuildContext {
  String tr(String key, {Map<String, String>? params}) {
    final controller = LingoWrapper.of(this);
    return controller.translate(key, params: params);
  }

  void setLocale(String newLocale) {
    final controller = LingoWrapper.of(this);
    controller.setLocale(newLocale);
  }

  String get currentLocale {
    final controller = LingoWrapper.of(this);
    return controller.currentLocale;
  }

  List<String> get availableLocales {
    final controller = LingoWrapper.of(this);
    return controller.availableLocales;
  }
}
