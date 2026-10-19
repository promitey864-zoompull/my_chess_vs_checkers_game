# Chess vs Checkers (Шахматы против Шашек)

Оффлайн-игра на Flutter: шахматный король и пешки против шашек ИИ.

## Сборка APK

### Вариант 1 — через GitHub Actions (без локального окружения)

Workflow [`.github/workflows/build_apk.yml`](.github/workflows/build_apk.yml) собирается на `ubuntu-latest`
и выкладывает результат как артефакт сборки:

1. Откройте вкладку **Actions** в репозитории → **Build Android APK** → выберите последний успешный запуск.
2. Внизу, в разделе **Artifacts**, скачайте `chess-vs-checkers-android`.
3. Внутри — `app-release.apk` (универсальный, для установки на телефон),
   `app-debug.apk` (с отладочными инструментами) и `app-release.aab` (для Google Play).

Можно запустить сборку вручную: **Actions → Build Android APK → Run workflow**
(есть поле для переопределения версии Flutter).

При пуше тега вида `v1.0.0` APK и AAB дополнительно прикрепляются к GitHub Release.

### Вариант 2 — локально

Нужны Flutter SDK (3.47+) и Android SDK/NDK (ставятся вместе с Android Studio):

```bash
flutter pub get
flutter build apk --release          # build/app/outputs/flutter-apk/app-release.apk
flutter build apk --split-per-abi    # отдельные APK под arm64-v8a / armeabi-v7a (меньше вес)
```

## Структура Android-модуля

| Файл | Назначение |
| --- | --- |
| `android/settings.gradle` | версии плагинов (AGP 9.1.0, Kotlin 2.4.0) и подключение Gradle-плагина Flutter |
| `android/build.gradle` | репозитории и перенаправление каталога сборки в `../build` |
| `android/app/build.gradle` | `applicationId`, SDK-версии, подписывание, блок `flutter { source = "../.." }` |
| `android/gradle.properties` | `android.useAndroidX=true`, JVM-настройки |
| `android/app/src/main/AndroidManifest.xml` | имя пакета, иконка, темы |
| `android/app/src/main/res/` | иконки `ic_launcher.png` и splash-темы |

`android/local.properties` (пути к SDK на вашей машине) в Git не хранится — Flutter
генерирует его сам при сборке.

## Важно перед публикацией в Google Play

* Сейчас `release` подписывается **отладочным ключом** — для установки на устройство этого
  достаточно, для Play Store нужен собственный ключ:

  ```bash
  keytool -genkeypair -v -keystore chess-release.jks -keyalg RSA -keysize 2048 \
    -validity 10000 -alias chess
  ```

  затем `android/key.properties` (`storePassword`, `keyPassword`, `storeFile`) и `signingConfigs`
  в `android/app/build.gradle`. Файлы `*.jks`, `*.keystore` и `key.properties` уже в `.gitignore`.
* `applicationId` сейчас `com.example.chess_vs_checkers` — для публикации замените на свой
  (он же влияет на пакет в `MainActivity.kt`, `namespace` и путь к файлу).
* Иконка — заглушка из шаблона Flutter, замените `android/app/src/main/res/mipmap-*/ic_launcher.png`
  или сгенерируйте через пакет `flutter_launcher_icons`.
