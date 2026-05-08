# Firebase Auth
-keepattributes Signature
-keepattributes *Annotation*

# Firestore models — prevent stripping
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Keep Firestore model classes
-keepclassmembers class * {
    @com.google.firebase.firestore.PropertyName *;
}

# Prevent R8 from stripping error/exception classes
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**
