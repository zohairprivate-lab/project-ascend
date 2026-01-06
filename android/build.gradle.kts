buildscript {
    repositories {
        google()
        maven { url = uri("https://maven-central.storage-download.googleapis.com/maven2/") }
        maven { url = uri("https://storage.googleapis.com/download.flutter.io") }
    }
}

allprojects {
    repositories {
        google()
        maven { url = uri("https://maven-central.storage-download.googleapis.com/maven2/") }
        maven { url = uri("https://storage.googleapis.com/download.flutter.io") }
        maven { url = uri("https://jitpack.io") }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
    
    buildscript {
        repositories {
            google()
            maven { url = uri("https://maven-central.storage-download.googleapis.com/maven2/") }
            maven { url = uri("https://storage.googleapis.com/download.flutter.io") }
        }
        configurations.all {
            resolutionStrategy {
                force("com.android.tools.build:gradle:8.7.0")
                force("org.jetbrains.kotlin:kotlin-stdlib:2.1.0")
                force("org.jetbrains.kotlin:kotlin-stdlib-jdk8:2.1.0")
            }
        }
    }

    project.configurations.all {
        resolutionStrategy {
            force("com.android.tools.build:gradle:8.7.0")
            force("org.jetbrains.kotlin:kotlin-stdlib:2.1.0")
            force("org.jetbrains.kotlin:kotlin-stdlib-jdk8:2.1.0")
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
