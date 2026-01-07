import jetbrains.buildServer.configs.kotlin.*
import patches.buildTypes.Build

version = "2025.07"

project {
    description = "C# language server"

    buildType(Build)
}
