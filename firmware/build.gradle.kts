plugins {
    kotlin("jvm") version "2.2.20"
    application
}

group = "com.isel.lic.3"
version = "1.3"

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(kotlin("test"))

    implementation(files("./usbport.jar"))
}


application {
    mainClass.set("MainKt")
}

tasks.test {
    useJUnitPlatform()
}
kotlin {
    jvmToolchain(23)
}