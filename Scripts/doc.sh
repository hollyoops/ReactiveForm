#!/bin/sh

set -euo pipefail

xcodebuild docbuild \
  -scheme ReactiveForm \
  -destination generic/platform=iOS \
  -derivedDataPath DerivedData

DOC_DIR_NAME="ReactiveForm.doccarchive"
DOC_PATH=$(find DerivedData -type d -name ${DOC_DIR_NAME})

echo "Move documentation from ${DOC_PATH} to ${DOC_DIR_NAME}"
mv ${DOC_PATH} ${DOC_DIR_NAME}
