#!/bin/bash
set -euxo pipefail

gh release create v2.93.22 --title v2.93.22 --notes "" roslyn-x86_64-unknown-linux-gnu.tar.gz
