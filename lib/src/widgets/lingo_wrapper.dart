import 'package:flutter/material.dart';
import '../core/lingo_controller.dart';
import '../core/translation_map.dart';
import '../core/json_loader.dart';

class LingoWrapper extends StatefulWidget {
  final Widget child;
  final String defaultLocale;
  final List<String> supportedLocales;
  final String assetsPath;
  final Map<String, Map<String, String>>? translations;
  final Widget? loadingWidget;

  const LingoWrapper({
    super.key,
    required this.child,
    required this.defaultLocale,
    required this.supportedLocales,
    this.assetsPath = "assets/lang",
    this.translations,
    this.loadingWidget,
  });

  @override
  State<LingoWrapper> createState() => _LingoWrapperState();

  /// Hızlı erişim ve dinamik yeniden çizim için LingoController'ı döndürür.
  /// [listen] parametresi false ise dil değiştiğinde çağıran widget rebuild olmaz (örn. Butonlar).
  static LingoController of(BuildContext context, {bool listen = true}) {
    final inherited = listen
        ? context.dependOnInheritedWidgetOfExactType<_InheritedLingo>()
        : context.getInheritedWidgetOfExactType<_InheritedLingo>();
    assert(inherited != null,
        'LingoWrapper widget bulunamadı. Lütfen widget ağacınızın üzerinde LingoWrapper olduğundan emin olun.');
    return inherited!.controller;
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
      translations = widget.translations!;
    } else {
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
          return widget.loadingWidget ??
              const Scaffold(
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
          builder: (context, _) {
            return _InheritedLingo(
              controller: _controller,
              locale: _controller.currentLocale,
              child: widget.child,
            );
          },
        );
      },
    );
  }
}

class _InheritedLingo extends InheritedWidget {
  final LingoController controller;
  final String locale;

  const _InheritedLingo({
    required this.controller,
    required this.locale,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedLingo oldWidget) {
    return oldWidget.locale != locale;
  }
}
