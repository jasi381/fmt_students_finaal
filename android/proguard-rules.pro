-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.editing.** { *; }
-keep class **.zego.**{*;}

# Keep Flutter Custom Tabs classes
-keep class com.github.droibit.flutter.customtabs.** { *; }

# Keep all browser-related classes for custom tabs
-keep class androidx.browser.customtabs.** { *; }

-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}
-optimizations !method/inlining/
-keepclasseswithmembers class * {
  public void onPayment*(...);
}
# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Remove unused classes and methods
-allowaccessmodification
-overloadaggressively

# Optimize
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5
