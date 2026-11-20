allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Keep Flutter's build output in the project-level build directory.
val newBuildDir = rootProject.layout.projectDirectory.dir("../build")
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    layout.buildDirectory.set(newBuildDir.dir(name))

    // Apply the compileSdk override after each Android library project's
    // build script has finished configuring its Android extension.
    afterEvaluate {
        extensions.findByType(com.android.build.api.dsl.LibraryExtension::class.java)
            ?.compileSdk = 36
    }
}

subprojects {
    evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
