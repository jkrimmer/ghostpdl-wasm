#!/bin/bash
GSVER=10.03.0
EMSDKVER=3.1.63

# Change to current directory of setup script
INITDIR="$PWD"
BUILDDIR="$PWD/$(dirname "${BASH_SOURCE}")"
cd "$BUILDDIR"

# Make sure the ghostpdl submodule is loaded
git submodule update --init --recursive

# Checkout desired version of the ghostpdl submodule
cd "$BUILDDIR/ghostpdl"
git checkout gs$GSVER
cd "$BUILDDIR"

# Check if emscripten has been cloned before
if [ -d "$BUILDDIR/emsdk" ]; then
    echo "Directory emsdk exists. Will pull updates if necessary."
else
    echo "Directory emsdk does not exist. Clone."
    # Get the emsdk repo
    git clone https://github.com/emscripten-core/emsdk.git
fi

cd "$BUILDDIR/emsdk"

# Get currently checked-out branch/tag
curEMSDKVER="$(git symbolic-ref -q --short HEAD || git describe --tags --exact-match 2>&1)"

if [ "$curEMSDKVER" != "$EMSDKVER" ]; then
    git pull
    # Checkout the desired version
    git checkout $EMSDKVER
    # Download and install the SDK tools.
    ./emsdk install $EMSDKVER
    # Activate emsdk
    ./emsdk activate $EMSDKVER
fi

# Go back to the starting point
cd "$INITDIR"
