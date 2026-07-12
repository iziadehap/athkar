import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.iziadehap.athkar"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // ✅ استخدام Java 11 بدلاً من 17 للتوافق الأفضل
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        
        // ✅ 🔥 تفعيل desugaring (هذا أهم إصلاح)
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    signingConfigs {
        create("release") {
            val keystoreProperties = Properties()
            val keystorePropertiesFile = rootProject.file("key.properties")
            if (keystorePropertiesFile.exists()) {
                keystoreProperties.load(FileInputStream(keystorePropertiesFile))
                keyAlias = keystoreProperties["keyAlias"].toString()
                keyPassword = keystoreProperties["keyPassword"].toString()
                storeFile = file(keystoreProperties["storeFile"].toString())
                storePassword = keystoreProperties["storePassword"].toString()
            }
        }
    }

    defaultConfig {
        applicationId = "com.iziadehap.athkar"
        // ✅ تحديد minSdk صريح (21 هو الحد الأدنى الموصى به)
        minSdk = flutter.minSdkVersion  // أو flutter.minSdkVersion إذا كان 21+
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // ✅ تفعيل MultiDex لتجنب تجاوز حد الـ 64K
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            // ✅ تمكين الضغط والتحسين للإصدار النهائي
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
            // ✅ تسريع البناء في وضع التطوير
            isMinifyEnabled = false
        }
    }
}

flutter {
    source = "../.."
}

// ✅ 🔥 إضافة تبعية desugaring (هذا أهم إصلاح)
dependencies {
    // لدعم Java 8+ APIs على الإصدارات القديمة من Android
    // اختر الإصدار المناسب حسب إصدار AGP
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
    // للـ MultiDex support
    implementation("androidx.multidex:multidex:2.0.1")
}
