## 1.0.0

* Initial release of `lingo_easy`!
* **Instant Language Switching:** Seamlessly change the application's locale using a custom `InheritedWidget` system that triggers rebuilds only where translations are used.
* **Nested Translations:** Supports nested JSON structures (e.g. `{ "home": { "title": "Ana Sayfa" } }`) flattened automatically into easy dot-notation keys like `"home.title"`.
* **Parameterized Translations:** Replace dynamic values on the fly (e.g. `welcome_message: "Welcome, {name}!"`).
* **Easy Context Extensions:** Access translations and locales easily through `context.tr('key')`, `context.setLocale('en')`, `context.currentLocale`, and `context.availableLocales`.
* **Custom Loading UI:** Provide an optional `loadingWidget` to customize the interface shown while translation JSON files are being parsed.
* **Pub.dev Ready:** Fully documented example, clean APIs, and 100% test coverage.
