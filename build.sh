#!/bin/bash
set -euxo pipefail

df -h /
du -sh . .git 2>/dev/null || true
du -sh /opt/teamcity-agent/system /opt/teamcity-agent/work ~/.nuget ~/.local/share/NuGet 2>/dev/null || true

rm -rf .git

rm -rf dotnet
mkdir -p dotnet
DOTNET_VERSION=$(grep -o '"dotnet": *"[^"]*"' global.json | cut -d'"' -f4)
curl -L "https://builds.dotnet.microsoft.com/dotnet/Sdk/${DOTNET_VERSION}/dotnet-sdk-${DOTNET_VERSION}-linux-x64.tar.gz" \
  | tar xzf - -C dotnet

export DOTNET_ROOT=$(pwd)/dotnet
export PATH="$DOTNET_ROOT:$PATH"

rm -rf dist
dotnet publish src/LanguageServer/Microsoft.CodeAnalysis.LanguageServer \
    -c Release \
    -o dist \
    -r linux-x64 \
    --self-contained true \
    --no-cache \
    -p:SelfContained=true \
    -p:PublishSingleFile=true \
    -p:UseAppHost=true \
    -p:RuntimeIdentifiers=linux-x64 \
    -p:EnableRuntimePackDownload=true \
    -p:EnableAppHostPackDownload=true \
    -p:PublishReadyToRun=false \
    -p:IncludeSymbols=false \
    -p:DebugType=None \
    -p:EnableWindowsTargeting=false

cp dist/Microsoft.CodeAnalysis.LanguageServer .
rm -rf dist dotnet artifacts
