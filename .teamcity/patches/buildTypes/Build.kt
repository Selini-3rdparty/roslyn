package patches.buildTypes

import jetbrains.buildServer.configs.kotlin.*
import jetbrains.buildServer.configs.kotlin.buildSteps.script

object Build : BuildType({
    name = "build"
    description = "Build roslyn language server"

    vcs {
        root(DslContext.settingsRoot)
    }

    steps {
        script {
            name = "Build"
            scriptContent = "./build.sh"
        }
    }

    artifactRules = "Microsoft.CodeAnalysis.LanguageServer"
})
