# LingoEasy 🌐

A light, super-fast, and easy-to-use localization package for Flutter applications. Manage multiple languages, parameterized values, nested JSON configurations, and dynamically switch languages instantly.

[![pub package](https://img.shields.io/pub/v/lingo_easy.svg)](https://pub.dev/packages/lingo_easy)
[![License: MIT](https://img.shields.io/badge/License-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![Flutter Platform Support](https://img.shields.io/badge/platform-flutter-blue.svg)](https://flutter.dev)

---

## Features ✨

- 🚀 **Instant Locale Switching:** Change languages dynamically at runtime.
- 🧱 **InheritedWidget Architecture:** Rebuilds only the widgets that actually consume translation keys.
- 📂 **Nested JSON support:** Organize translation assets hierarchically (e.g., `"button.save"` maps to `{"button": {"save": "..."}}`).
- 💬 **Parameterized Translations:** Replace placeholders dynamically (e.g., `"Welcome, {name}!"`).
- ⚡ **Performance Optimized:** Avoid unnecessary rebuilds using smart extension methods.
- 📦 **Zero Boilerplate:** Use intuitive BuildContext extensions to translate (`context.tr()`), change language (`context.setLocale()`), and retrieve active states.

---

## Installation 📦

Add `lingo_easy` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  lingo_easy: ^1.0.0
```

---

## Getting Started 🚀

### 1. Create Translation Files
Create your translation files under `assets/lang/` (or any custom directory) in JSON format:

**`assets/lang/en.json`**
```json
{
  "welcome_message": "Welcome, {name}!",
  "app_title": "LingoEasy Demo",
  "button": {
    "change_language": "Change Language",
    "click_me": "Click Me"
  },
  "nested": {
    "deep": {
      "text": "This is a nested translation text."
    }
  }
}
```

**`assets/lang/tr.json`**
```json
{
  "welcome_message": "Hoş geldiniz, {name}!",
  "app_title": "LingoEasy Örneği",
  "button": {
    "change_language": "Dili Değiştir",
    "click_me": "Tıkla"
  },
  "nested": {
    "deep": {
      "text": "Bu iç içe geçmiş bir çeviri metnidir."
    }
  }
}
```

### 2. Update `pubspec.yaml` Assets
Ensure your assets directory is declared in your project's `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/lang/
```

### 3. Initialize `LingoWrapper`
Wrap your widget tree (usually inside `MaterialApp`'s `home` or `builder`) with `LingoWrapper`:

```dart
import 'package:flutter/material.dart';
import 'package:lingo_easy/lingo_easy.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LingoEasy Demo',
      home: LingoWrapper(
        defaultLocale: 'en',
        supportedLocales: const ['en', 'tr'],
        assetsPath: 'assets/lang', // Optional (Defaults to assets/lang)
        loadingWidget: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ), // Optional
        child: const HomeScreen(),
      ),
    );
  }
}
```

---

## Usage Guide 📖

Once configured, use the provided `BuildContext` extensions to translate values, check language states, and change settings.

### Basic Translation
```dart
Text(context.tr('app_title'))
```

### Parameterized Translation
```dart
Text(context.tr('welcome_message', params: {'name': 'Fatih'}))
// Output (English): Welcome, Fatih!
// Output (Turkish): Hoş geldiniz, Fatih!
```

### Nested Keys (Dot-notation)
Nested maps are automatically flattened at startup into dot-notation paths:
```dart
Text(context.tr('button.click_me'))
Text(context.tr('nested.deep.text'))
```

### Switch Language
Changing the language updates only the widgets consuming translations:
```dart
ElevatedButton(
  onPressed: () {
    context.setLocale('tr'); // Switches locale to Turkish
  },
  child: Text(context.tr('button.change_language')),
)
```

### Active & Available Locales
```dart
print(context.currentLocale);      // 'en' or 'tr'
print(context.availableLocales);  // ['en', 'tr']
```

---

## API Reference 🛠️

| Extension Method / Parameter | Return Type | Description | Rebuilds Widget? |
| --- | --- | --- | --- |
| `context.tr(String key, {Map<String, String>? params})` | `String` | Returns the translated string. Replaces placeholders in `{parameter}` format. Returns key if missing. | **Yes** |
| `context.setLocale(String newLocale)` | `void` | Changes the active application locale and triggers reactive rebuilds. | No |
| `context.currentLocale` | `String` | Returns the active locale code (e.g., `'en'`). | **Yes** |
| `context.availableLocales` | `List<String>` | Returns all supported locale codes defined in the wrapper. | No |

---

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
