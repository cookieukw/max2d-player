# Max2D Player

🌐 [Ler em Português](./docs/README.pt-BR.md)

> **Max2D Source Archive (2020)**
> Original system created by **Glenn Mejias** and the Max2D team (2020).
> This project can be freely used to build your own APKs — released under the [Unlicense](./LICENSE).

Max2D Player is the game runner/executor of the Max2D engine — a Flutter runtime that loads and runs `.mobilegameengine` scenes on Android devices. Originally part of the Max2D ecosystem, the source code has been made available so anyone can compile their own APKs.

---

## ✅ What Was Updated (2025–2026)

| Area | What Changed |
|------|-------------|
| **Android Build** | Migrated to AGP 8.2.1, compileSdk 36, targetSdk 36 |
| **Dependencies** | `sensors` → `sensors_plus`, `firebase_admob` → `google_mobile_ads`, `flame` → `^1.0.0` |
| **Null Safety** | Dart code migrated to null safety (Dart 2.12+) |
| **APK Size** | Reduced from 49.4 MB to ~19 MB via R8, ABI splits, and obfuscation |
| **ProGuard** | Rules added in `android/app/proguard-rules.pro` |
| **License** | Migrated to **Unlicense** (public domain) |
| **Cleanup** | Removed debug logs, leftover files, and unnamed scenes |
| **Local Plugin** | `control_pad` maintained at `plugins/control_pad/` |

---

## 📁 Project Structure

```
max2d-player/
├── lib/                        # Main Dart source code
│   ├── main.dart               # Entry point — extracts assets and starts the player
│   ├── gameplayer.dart         # Main player widget
│   ├── gameview.dart           # Canvas rendering
│   ├── globalvars.dart         # Runtime global variables
│   ├── actions.dart            # Engine action/event system
│   ├── compandactvariables.dart# Components: physics, collision, sprites, etc.
│   └── admobads2.dart          # Google Mobile Ads integration
│
├── files/                      # Example project bundled in the APK
│   ├── projectsettings.mobilegameengine   # Project settings
│   ├── images/                 # Sprites and visual assets
│   └── scenes/
│       ├── scene1.mobilegameengine        # Main scene
│       └── loading.mobilegameengine       # Loading scene
│
├── assets/                     # Flutter assets
│   ├── fonts/                  # 14 custom fonts
│   ├── logo.png                # Max2D logo
│   └── defimage.png            # Default image
│
├── jogos/                      # Example game projects
│   ├── Loading/                # Loading screen project
│   └── Mira Brawl/             # Demo game project
│
├── plugins/
│   └── control_pad/            # Local virtual joystick plugin
│
└── android/                    # Native Android configuration
    └── app/
        ├── build.gradle        # Build config (R8, ABI splits)
        └── proguard-rules.pro  # Obfuscation rules
```

---

## 🔨 How to Build

### Prerequisites
- Flutter SDK (latest stable version)
- Android SDK with API 36

### APK Build (per-architecture — smaller and optimized)

```bash
flutter build apk --release --obfuscate --split-debug-info=build/symbols/ --split-per-abi
```

APKs are generated at `build/app/outputs/flutter-apk/`:

| File | Size | Use |
|------|------|-----|
| `app-arm64-v8a-release.apk` | ~19 MB | Modern Android (64-bit) ✅ recommended |
| `app-armeabi-v7a-release.apk` | ~17 MB | Older Android (32-bit) |
| `app-x86_64-release.apk` | ~21 MB | Emulators |

### App Bundle Build (for Play Store)

```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols/
```

---

## 🎮 What's Available

- **Scene runtime** for `.mobilegameengine` files — loads and runs scenes created by the Max2D editor
- **Component system**: sprites, colliders, camera, scripts, physics (Box2D via flame_forge2d)
- **Action system**: touch inputs, scene loading, variables, conditional logic
- **Virtual joystick** (`control_pad`) — on-screen gamepad support
- **Accelerometer and gyroscope** via `sensors_plus`
- **Audio** via `audioplayers`
- **Ads** via `google_mobile_ads`
- **Microphone** via `record`
- **14 custom fonts** bundled (arcade, handwriting, pixel, etc.)

---

## 📜 License

Source code released under the **[Unlicense](./LICENSE)** — public domain.
Original project created by **Glenn Mejias** and the Max2D team (2020).

The fonts in `assets/fonts/` belong to their respective authors — see the [LICENSE](./LICENSE) file for details.