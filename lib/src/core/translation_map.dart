class TranslationMap {
  final Map<String, Map<String, String>> _data = {};

  TranslationMap(Map<String, Map<dynamic, dynamic>> data) {
    data.forEach((locale, map) {
      final flattened = <String, String>{};
      _flattenMap('', Map<String, dynamic>.from(map), flattened);
      _data[locale] = flattened;
    });
  }

  /// Yeni bir dil ekler (çalışma anında)
  void addLocale(String localeCode, Map<dynamic, dynamic> translations) {
    final flattened = <String, String>{};
    _flattenMap('', Map<String, dynamic>.from(translations), flattened);
    _data[localeCode] = flattened;
  }

  void _flattenMap(String prefix, Map<String, dynamic> source,
      Map<String, String> destination) {
    source.forEach((key, value) {
      final newKey = prefix.isEmpty ? key : '$prefix.$key';
      if (value is Map) {
        _flattenMap(newKey, Map<String, dynamic>.from(value), destination);
      } else {
        destination[newKey] = value.toString();
      }
    });
  }

  /// Belirtilen dildeki çeviriyi döndürür
  String? translate(String locale, String key) {
    return _data[locale]?[key];
  }

  /// Dil var mı?
  bool hasLocale(String locale) => _data.containsKey(locale);

  /// Tüm dillerin listesi
  List<String> get availableLocales => _data.keys.toList();
}
