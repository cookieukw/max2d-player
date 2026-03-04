# Flutter/Dart
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Google Mobile Ads
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }

# audioplayers
-keep class xyz.luan.audioplayers.** { *; }

# Sensors Plus
-keep class dev.fluttercommunity.plus.sensors.** { *; }

# Record plugin
-keep class com.llfbandit.record.** { *; }

# Path Provider
-keep class io.flutter.plugins.pathprovider.** { *; }

# Flutter Archive
-keep class com.example.flutter_archive.** { *; }

# Keep Kotlin metadata (can cause subtle issues if not kept)
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Suppress warnings for libraries that include non-Android JARs
-dontwarn java.awt.**
-dontwarn javax.annotation.**
-dontwarn org.conscrypt.**
