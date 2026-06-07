class TranslationMap {
  final Map<String, Map<String, String>> _data;

  TranslationMap(this._data);

  /// Yeni bir dil ekler (çalışma anında)
  void addLocale(String localeCode, Map<String, String> translations) {
    _data[localeCode] = translations;
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
