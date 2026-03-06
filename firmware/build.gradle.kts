plugins {
    kotlin("jvm") version "2.0.0"
	application
}

group = "com.isel.lic.3"
version = "1.0"

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(kotlin("test"))
    implementation(files("libs/usbPort_LinuxMacOS.jar"))
}
application {
    mainClass.set("MainKt") 
}
tasks.test {
    useJUnitPlatform()
}
kotlin {
    jvmToolchain(21)
}
