# gspdl-wasm
1. Clone this repository
```
git clone https://github.com/jkrimmer/ghostpdl-wasm
cd ghostpdl-wasm
```
2. Run the setup bash script
```
. build/setup.sh
```
3. Activate PATH and other environment variables for emsdk in the current terminal
```
source build/emsdk/emsdk_env.sh
```
4. Run the build script to generate the full set of binaries
```
. build/build.sh
```
4. Alternatively, run the script `build-inkcov-only.sh` to generate only a ghostscript binary featuring nothing but the inkcov device.
```
. build/build-inkcov-only.sh
```
5. Find the output in `ghostpdl-wasm/build/ghostpdl/bin`.
