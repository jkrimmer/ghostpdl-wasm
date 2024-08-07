#!/bin/bash
INITDIR="$PWD"
BUILDDIR="$PWD/$(dirname "${BASH_SOURCE}")"
EMCC_FLAGS_DEBUG="-g"
EMCC_FLAGS_RELEASE="-O3 -flto"

#export CFLAGS="$EMCC_FLAGS_DEBUG"
export CFLAGS="$EMCC_FLAGS_RELEASE"
#export EMCC_DEBUG=1

cd "$BUILDDIR/ghostpdl"
# Apply ghostpdl patch to avoid function pointer issues
git apply "$BUILDDIR/fix-Wcast-function-type-mismatch.patch"

emconfigure ./autogen.sh \
  --host="wasm32" \
  --disable-cups \
  --disable-dbus \
  --disable-gtk \
  --without-x \
  --without-ijs \
  --without-pdftoraster \
  --without-ufst \
  --without-libpaper \
  --with-xps="no" \
  --with-drivers=inkcov \
  --with-pcl="no" \
#  --disable-compile-inits \

export GS_LDFLAGS="\
-s EXIT_RUNTIME=0 \
-s ALLOW_MEMORY_GROWTH=1 \
-s STACK_SIZE=256kb \
-s WASM=1 \
-s STANDALONE_WASM=0 \
-s ERROR_ON_UNDEFINED_SYMBOLS=1 \
-s WASM_BIGINT=1 \
-s FORCE_FILESYSTEM \
-s EXPORT_ES6 \
-s MODULARIZE=1 \
-s EXPORT_NAME=gs \
-s INVOKE_RUN=0 \
-s EXPORTED_RUNTIME_METHODS='["callMain","FS"]' \
--closure 1 \
"
# the following two flags are necessary if we do not patch ghostscript such that it avoids function pointer mismatches
#-s EMULATE_FUNCTION_POINTER_CASTS \
#-s BINARYEN_EXTRA_PASSES="--pass-arg=max-func-params@70" \

# for file embedding
#--embed-file $ROOT/ghostpdl/Resource/Init/@Resource/Init \
#--embed-file $ROOT/ghostpdl/Resource/Font/@Resource/Font \
#--embed-file $ROOT/ghostpdl/iccprofiles@iccprofiles \

emmake make LDFLAGS="$LDFLAGS $GS_LDFLAGS" -j

# Go back to the starting point
cd "$INITDIR"
