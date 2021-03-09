DATE=$(date +"%F")

clone () {
git clone --depth=1 https://github.com/nbr-project/arm64-gcc -b master gcc
git clone --depth=1 https://github.com/nbr-project/arm32-gcc -b master gcc32
git clone --depth=1 https://github.com/nbr-project/AnyKernel3 -b ulysse anykernel-3
}

export ARCH=arm64
export SUBARCH=arm64
export PATH="$(pwd)/gcc/bin:$(pwd)/gcc32/bin:/usr/lib/ccache:$PATH"
export USE_CCACHE=1
export CCACHE_DIR="/.ccache"
export CROSS_COMPILE="ccache aarch64-none-linux-gnu-"
export CROSS_COMPILE_ARM32="ccache arm-none-eabi-"
export KBUILD_BUILD_HOST=buildbot
export KBUILD_BUILD_USER=mamles

compile () {
make O=out ulysse_defconfig
make O=out -j$(nproc --all) 2>&1 | tee buildlog.txt
}

repack () {
cp out/arch/arm64/boot/Image.gz-dtb anykernel-3
cd anykernel-3
zip -r9q NBR-Origin-4.9-ulysse-${DATE}.zip * -x .git README.md $(echo *.zip)
}

clone
compile
repack
