#!/bin/bash
set -euxo pipefail

DOTNET_VERSION=$(grep -o '"dotnet": *"[^"]*"' global.json | cut -d'"' -f4)
rm -rf dotnet && mkdir -p dotnet
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
    -p:IncludeAllContentForSelfExtract=true \
    -p:UseAppHost=true \
    -p:RuntimeIdentifiers=linux-x64 \
    -p:EnableRuntimePackDownload=true \
    -p:EnableAppHostPackDownload=true \
    -p:PublishReadyToRun=false \
    -p:IncludeSymbols=false \
    -p:DebugType=None \
    -p:EnableWindowsTargeting=false

mkdir -p bin
cp dist/Microsoft.CodeAnalysis.LanguageServer bin/
tar cvzf roslyn-x86_64-unknown-linux-gnu.tar.gz bin/
rm -rf dist dotnet artifacts bin
