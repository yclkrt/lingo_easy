import 'package:flutter/foundation.dart';
import 'translation_map.dart';

class LingoController extends ChangeNotifier {
  String _currentLocale;
  final TranslationMap _translationMap;

  LingoController({
    required String defaultLocale,
    required TranslationMap translationMap,
  })  : _currentLocale = defaultLocale,
        _translationMap = translationMap;

  String get currentLocale => _currentLocale;

  void setLocale(String newLocale) {
    if (_translationMap.hasLocale(newLocale)) {
      _currentLocale = newLocale;
      notifyListeners();
    } else {
      debugPrint('LingoEasy: "$newLocale" dili mevcut değil.');
    }
  }

  String translate(String key, {Map<String, String>? params}) {
    String? translated = _translationMap.translate(_currentLocale, key);

    if (params != null) {
      params.forEach((paramKey, paramValue) {
        translated = translated!.replaceAll('{$paramKey}', paramValue);
      });
    }

    return translated ?? '';
  }

  List<String> get availableLocales => _translationMap.availableLocales;
}
