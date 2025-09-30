import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("com.android.application") version "8.9.1" apply false
    id("org.jetbrains.kotlin.android") version "1.9.10" apply false
    id("dev.flutter.flutter-gradle-plugin") version "1.0.0" apply false
}

tasks.register<Delete>("clean", Delete::class) {
    delete(rootProject.buildDir)
}
