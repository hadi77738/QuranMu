# Flutter Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Keep Raw and Android Resources
-keepclassmembers class **.R$* {
    public static <fields>;
}

# Keep plugins
-keep class io.flutter.plugin.** { *; }
-keep class com.ryanheise.just_audio.** { *; }
-keep class com.baseflow.geolocator.** { *; }
