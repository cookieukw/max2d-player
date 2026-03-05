# Max2D Player

🌐 [Read in English](../readme.md)

> **Max2D Source Archive (2020)**
> Sistema original criado por **Glenn Mejias** e o time Max2D (2020).
> Este projeto pode ser usado livremente para construir seus próprios APKs — lançado sob a [Unlicense](../LICENSE).

Max2D Player é o executor/player de jogos da engine Max2D — um runtime Flutter que carrega e roda cenas `.mobilegameengine` em dispositivos Android. Originalmente parte do ecossistema Max2D, o código-fonte foi disponibilizado para que qualquer pessoa possa compilar seus próprios APKs.

---

## ✅ O que foi atualizado (2025–2026)

| Área | O que mudou |
|------|-------------|
| **Build Android** | Migrado para AGP 8.2.1, compileSdk 36, targetSdk 36 |
| **Dependências** | `sensors` → `sensors_plus`, `firebase_admob` → `google_mobile_ads`, `flame` → `^1.0.0` |
| **Null Safety** | Código Dart migrado para null safety (Dart 2.12+) |
| **Tamanho do APK** | Reduzido de 49.4 MB para ~19 MB via R8, splits por ABI e obfuscação |
| **ProGuard** | Regras adicionadas em `android/app/proguard-rules.pro` |
| **Licença** | Migrado para **Unlicense** (domínio público) |
| **Organização** | Remoção de logs de debug, arquivos residuais e cenas sem nome |
| **Plugin local** | `control_pad` mantido em `plugins/control_pad/` |

---

## 📁 Estrutura do Projeto

```
max2d-player/
├── lib/                        # Código Dart principal
│   ├── main.dart               # Entry point — descomprime assets e inicia o player
│   ├── gameplayer.dart         # Widget principal do player
│   ├── gameview.dart           # Renderização do canvas
│   ├── globalvars.dart         # Variáveis globais do runtime
│   ├── actions.dart            # Sistema de ações/eventos da engine
│   ├── compandactvariables.dart# Componentes: física, colisão, sprites, etc.
│   └── admobads2.dart          # Integração com Google Mobile Ads
│
├── files/                      # Projeto de exemplo embutido no APK
│   ├── projectsettings.mobilegameengine   # Configurações do projeto
│   ├── images/                 # Sprites e assets visuais
│   └── scenes/
│       ├── scene1.mobilegameengine        # Cena principal
│       └── loading.mobilegameengine       # Cena de carregamento
│
├── assets/                     # Assets Flutter
│   ├── fonts/                  # 14 fontes customizadas
│   ├── logo.png                # Logo do Max2D
│   └── defimage.png            # Imagem padrão
│
├── jogos/                      # Projetos de jogos de exemplo
│   ├── Loading/                # Projeto de tela de loading
│   └── Mira Brawl/             # Projeto de jogo demo
│
├── plugins/
│   └── control_pad/            # Plugin local de joystick virtual
│
└── android/                    # Configurações Android nativas
    └── app/
        ├── build.gradle        # Configuração de build (R8, splits ABI)
        └── proguard-rules.pro  # Regras de ofuscação
```

---

## 🔨 Como Compilar

### Pré-requisitos
- Flutter SDK (versão estável mais recente)
- Android SDK com API 36

### Build do APK (por arquitetura — menor e otimizado)

```bash
flutter build apk --release --obfuscate --split-debug-info=build/symbols/ --split-per-abi
```

APKs gerados em `build/app/outputs/flutter-apk/`:

| Arquivo | Tamanho | Uso |
|---------|---------|-----|
| `app-arm64-v8a-release.apk` | ~19 MB | Android moderno (64-bit) ✅ recomendado |
| `app-armeabi-v7a-release.apk` | ~17 MB | Android antigo (32-bit) |
| `app-x86_64-release.apk` | ~21 MB | Emuladores |

### Build do App Bundle (para Play Store)

```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols/
```

---

## 🎮 O que está disponível

- **Runtime de cenas** `.mobilegameengine` — carrega e executa cenas criadas pelo editor Max2D
- **Sistema de componentes**: sprites, colisores, câmera, scripts, física (Box2D via flame_forge2d)
- **Sistema de ações**: inputs touch, carregamento de cenas, variáveis, lógica condicional
- **Joystick virtual** (`control_pad`) — suporte a gamepad na tela
- **Acelerômetro e giroscópio** via `sensors_plus`
- **Áudio** via `audioplayers`
- **Anúncios** via `google_mobile_ads`
- **Microfone** via `record`
- **14 fontes customizadas** embutidas (arcade, handwriting, pixel, etc.)

---

## 📜 Licença

Código-fonte lançado sob a **[Unlicense](../LICENSE)** — domínio público.
Projeto original criado por **Glenn Mejias** e o time Max2D (2020).

As fontes em `assets/fonts/` pertencem a seus respectivos autores — veja o arquivo [LICENSE](../LICENSE) para detalhes.
