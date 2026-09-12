import java.util.Properties
import java.io.FileInputStream

// ============================================================
// LECTURE DES PROPRIÉTÉS DU KEYSTORE
// ============================================================

val keystoreProperties = Properties()

val keystorePropertiesFile =
    rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(
        FileInputStream(
            keystorePropertiesFile
        )
    )
}

// ============================================================
// PLUGINS
// ============================================================

plugins {
    id("com.android.application")

    // Firebase
    id("com.google.gms.google-services")

    // Flutter
    id("dev.flutter.flutter-gradle-plugin")
}

// ============================================================
// ANDROID
// ============================================================

android {

    // ========================================================
    // IDENTITÉ DE L'APPLICATION
    // ========================================================

    namespace = "com.babischool.mobile"

    compileSdk = 36

    ndkVersion = flutter.ndkVersion

    // ========================================================
    // CONFIGURATION DE SIGNATURE
    // ========================================================

    signingConfigs {

        create("release") {

            keyAlias =
                keystoreProperties["keyAlias"] as String

            keyPassword =
                keystoreProperties["keyPassword"] as String

            storeFile =
                keystoreProperties["storeFile"]?.let {
                    file(it)
                }

            storePassword =
                keystoreProperties["storePassword"] as String
        }
    }

    // ========================================================
    // JAVA
    // ========================================================

    compileOptions {

        sourceCompatibility =
            JavaVersion.VERSION_17

        targetCompatibility =
            JavaVersion.VERSION_17

        isCoreLibraryDesugaringEnabled = true
    }

    // ========================================================
    // CONFIGURATION PAR DÉFAUT
    // ========================================================

    defaultConfig {

        // PACKAGE GOOGLE PLAY
        applicationId =
            "com.babischool.mobile"

        // SDK
        minSdk =
            flutter.minSdkVersion

        targetSdk = 36

        // VERSION
        versionCode =
            flutter.versionCode

        versionName =
            flutter.versionName
    }

    // ========================================================
    // BUILD TYPES
    // ========================================================

    buildTypes {

        release {

            signingConfig =
                signingConfigs.getByName(
                    "release"
                )

            isMinifyEnabled = false

            isShrinkResources = false
        }
    }
}

// ============================================================
// DÉPENDANCES
// ============================================================

dependencies {

    coreLibraryDesugaring(
        "com.android.tools:desugar_jdk_libs:2.1.4"
    )
}

// ============================================================
// KOTLIN
// ============================================================

kotlin {

    compilerOptions {

        jvmTarget =
            org.jetbrains.kotlin.gradle.dsl
                .JvmTarget.JVM_17
    }
}

// ============================================================
// FLUTTER
// ============================================================

flutter {
    source = "../.."
}