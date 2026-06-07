import 'package:flutter/material.dart';
import '../core/lingo_controller.dart';
import '../core/translation_map.dart';
import '../core/json_loader.dart';

class LingoWrapper extends StatefulWidget {
  final Widget child;
  final String defaultLocale;
  final List<String> supportedLocales; // Burada tanımlı
  final String assetsPath;
  final Map<String, Map<String, String>>? translations;

  const LingoWrapper({
    super.key,
    required this.child,
    required this.defaultLocale,
    required this.supportedLocales, // Zorunlu parametre
    this.assetsPath = "assets/lang",
    this.translations,
  });

  @override
  State<LingoWrapper> createState() => _LingoWrapperState();

  static LingoController of(BuildContext context) {
    final state = context.findAncestorStateOfType<_LingoWrapperState>();
    assert(state != null, 'LingoWrapper widget bulunamadı');
    return state!._controller;
  }
}

class _LingoWrapperState extends State<LingoWrapper> {
  late Future<LingoController> _controllerFuture;
  late LingoController _controller;

  @override
  void initState() {
    super.initState();
    _controllerFuture = _initializeController();
  }

  Future<LingoController> _initializeController() async {
    Map<String, Map<String, String>> translations;

    if (widget.translations != null) {
      // Direkt map kullanımı
      translations = widget.translations!;
    } else {
      // JSON'dan yükleme
      translations = await JsonTranslationLoader.loadFromAssets(
        assetsPath: widget.assetsPath,
        locales: widget.supportedLocales,
      );
    }

    final translationMap = TranslationMap(translations);
    _controller = LingoController(
      defaultLocale: widget.defaultLocale,
      translationMap: translationMap,
    );

    return _controller;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LingoController>(
      future: _controllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('LingoEasy Hatası: ${snapshot.error}')),
          );
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => widget.child,
        );
      },
    );
  }
}
