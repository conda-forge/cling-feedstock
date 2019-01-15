#!/bin/bash

if [[ `uname` == "Darwin" ]]; then
    echo "Activating cling"
    PRODUCT_VERSION=$(sw_vers -productVersion)
    OSX_VERSIONS=( ${PRODUCT_VERSION//./ } )
    OSX_VERSION_MAJOR="${OSX_VERSIONS[0]}"
    OSX_VERSION_MINOR="${OSX_VERSIONS[1]}"
    if [ "$OSX_VERSION_MAJOR" -ge "10" ]&& [ "$OSX_VERSION_MINOR" -ge "14" ]; then
        export CLING_INCLUDE_PATHS=$(xcode-select -p)/SDKs/MacOSX.sdk/usr/include
    else
        export CLING_INCLUDE_PATHS=/usr/include
    fi
fi
