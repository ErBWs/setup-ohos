#!/bin/bash

set -eu

if [ "$RUNNER_OS" == "Linux" ] && [ "$RUNNER_ARCH" == "X64" ]; then
    FILENAME=ohos-sdk-linux-amd64.tar.gz
elif [ "$RUNNER_OS" == "macOS" ]; then
    if [ "$RUNNER_ARCH" == "X64" ]; then
        FILENAME=ohos-sdk-mac-amd64.zip
    else
        FILENAME=ohos-sdk-mac-arm64.zip
    fi
elif [ "$RUNNER_OS" == "Windows" ] && [ "$RUNNER_ARCH" == "X64" ]; then
    FILENAME=ohos-sdk-windows-amd64.zip
else
    echo "Bad operating system, This action only supports Linux AMD64, Windows AMD64 and macOS."
    exit 1
fi

while getopts 'v:' OPTION; do
    case "$OPTION" in
    v) VERSION="$OPTARG" ;;
    esac
done

WORK_DIR="$HOME/ohos-sdk"

download_sdk() {
    mkdir -p $WORK_DIR
    cd $WORK_DIR

    gh release download $VERSION -p "$FILENAME.*" -R ErBWs/ohos-sdk

    cat $FILENAME.aa $FILENAME.ab > $FILENAME

    # Basically it never fails, so no retry here
    if ! sha256sum -c $FILENAME.sha256; then
        echo "Checksum failed, terminate workflow."
        exit 1
    fi

    echo Extracting...
    if [ "$RUNNER_OS" == "Linux" ]; then
        tar -xzf $FILENAME
    else
        unzip -q $FILENAME
    fi
    rm $FILENAME.*
}

if [ ! -x "$WORK_DIR/command-line-tools/bin/ohpm" ]; then
    download_sdk
fi

TOOL_PATH="$WORK_DIR/command-line-tools/bin"
NODE_PATH="$WORK_DIR/command-line-tools/tool/node/bin"
HOS_SDK_HOME="$WORK_DIR/command-line-tools/sdk"

cd $HOS_SDK_HOME/default
SDK_VERSION="$(jq -r '.data | .version' < sdk-pkg.json)"
API_VERSION="$(jq -r '.data | .apiVersion' < sdk-pkg.json)"

echo "sdk-version=$SDK_VERSION" >> $GITHUB_OUTPUT
echo "api-version=$API_VERSION" >> $GITHUB_OUTPUT

echo "$TOOL_PATH" >> $GITHUB_PATH
echo "$NODE_PATH" >> $GITHUB_PATH

# Export for flutter
echo "HOS_SDK_HOME=$WORK_DIR/command-line-tools/sdk" >> $GITHUB_ENV

# Export for ohrs
echo "OHOS_NDK_HOME=$WORK_DIR/command-line-tools/sdk/default/openharmony" >> $GITHUB_ENV

echo "Successfully setup $SDK_VERSION SDK with API$API_VERSION!"
