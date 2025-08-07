plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.firebase-perf")
}

android {
    namespace = "com.example.python_in_arabic"
    compileSdk = 35
    targetSdk = 35
    ndkVersion = "27.0.11718014"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.python_in_arabic"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
dependencies {
    // Firebase BoM (Bill of Materials) - بيظبط النسخ أوتوماتيك ✅
    implementation(platform("com.google.firebase:firebase-bom:34.0.0"))

    // اختار بقى اللي انت عايز تستخدمه 👇 (ضيفهم كلهم أو اللي تحتاجه بس)

    // Authentication
    implementation("com.google.firebase:firebase-auth-ktx")

    // Firestore
    implementation("com.google.firebase:firebase-firestore-ktx")

    // Storage
    implementation("com.google.firebase:firebase-storage-ktx")

    // Analytics (لو هتستخدمها)
    implementation("com.google.firebase:firebase-analytics-ktx")
}
