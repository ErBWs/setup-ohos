#!/bin/bash

set -eu

if [ "$RUNNER_OS" != "Linux" ] || [ "$RUNNER_ARCH" != "X64" ]; then
    echo "Bad operating system, This action only supports Linux X64."
    exit 1
fi

BASE_URL="https://github.com/ErBWs/ohos-sdk/releases"
VERSION=""

while getopts 'v:' OPTION; do
    case "$OPTION" in
    v) VERSION="$OPTARG" ;;
    esac
done

if [ "$VERSION" = "latest" ]; then
    BASE_URL=$BASE_URL/latest/download
else
    BASE_URL=$BASE_URL/download/$VERSION
fi

WORK_DIR="~/ohos-sdk"

download_sdk() {
    mkdir -p $WORK_DIR
    cd $WORK_DIR

    if ! curl -fsSL $BASE_URL/ohos-sdk-linux-amd64.tar.gz.sha256 -o ohos-sdk-linux-amd64.tar.gz.sha256; then
        echo "Bad download link, please confirm your version input is correct."
        exit 1
    fi

    echo Download SDK from $BASE_URL

    curl -fsSL $BASE_URL/ohos-sdk-linux-amd64.tar.gz.aa -o ohos-sdk-linux-amd64.tar.gz.aa
    curl -fsSL $BASE_URL/ohos-sdk-linux-amd64.tar.gz.ab -o ohos-sdk-linux-amd64.tar.gz.ab
    cat ohos-sdk-linux-amd64.tar.gz.aa ohos-sdk-linux-amd64.tar.gz.ab > ohos-sdk-linux-amd64.tar.gz

    # Basically it never fails, so no retry here
    if ! sha256sum -c ohos-sdk-linux-amd64.tar.gz.sha256; then
        echo "Checksum failed, terminate workflow."
        exit 1
    fi

    echo Extracting...
    tar -xzf ohos-sdk-linux-amd64.tar.gz
    rm ohos-sdk-linux-amd64.tar.*
}

if [ ! -x "$WORK_DIR/command-line-tools/bin/ohpm" ]; then
    download_sdk
fi

TOOL_PATH="~/ohos-sdk/command-line-tools/bin"
NODE_PATH="~/ohos-sdk/command-line-tools/tool/node/bin"
HOS_SDK_HOME="~/ohos-sdk/command-line-tools/sdk"

cd $HOS_SDK_HOME/default
SDK_VERSION="$(jq -r '.data | .version' < sdk-pkg.json)"
API_VERSION="$(jq -r '.data | .apiVersion' < sdk-pkg.json)"

echo "sdk-version=$SDK_VERSION" >> $GITHUB_OUTPUT
echo "api-version=$API_VERSION" >> $GITHUB_OUTPUT

echo "$TOOL_PATH" >> $GITHUB_PATH
echo "$NODE_PATH" >> $GITHUB_PATH

# Export for flutter
echo "HOS_SDK_HOME=~/ohos-sdk/command-line-tools/sdk" >> $GITHUB_ENV

echo "Successfully setup $SDK_VERSION SDK with API$API_VERSION!"
