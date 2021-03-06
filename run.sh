#! /bin/bash
set -xeo pipefail

DOCKERHASH=6603364284e4fe27f973e6d2e42b7eacf418baabf87b89638d46453772652d2e
DOCKERIMAGE=greenaddress/core_builder_for_android@sha256:$DOCKERHASH
docker pull $DOCKERIMAGE

ARCHS="armv7a-linux-androideabi=32 aarch64-linux-android=64 x86_64-linux-android=64 i686-linux-android=32"

build_repo() {
    for TARGETHOST in $ARCHS; do
        docker run -v $PWD:/repo $DOCKERIMAGE /bin/bash -c "/repo/fetchbuild.sh $1 $2 $3 $4 $5 ${TARGETHOST/=/ }" &
    done
}

build_repo https://github.com/bitcoin/bitcoin.git 2472733a24a9364e4c6233ccd04166a26a68cc65 bitcoin bitcoin --disable-man
build_repo https://github.com/bitcoinknots/bitcoin.git 5e1c2d13f506e58513064ecbd914e00a944ee6a0 bitcoin bitcoin --disable-man
build_repo https://github.com/elementsproject/elements.git 551483eae50ff2ee48ed17d6b22bb1a26284b635 elements liquid --enable-liquid

wait

echo "DONE"

printpackages() {
    echo
    for f in $(find . -type f -name "*$1.tar.xz" | sort)
    do
        shahash=$(sha256sum $f | cut -d" " -f1)
        filesize=$(ls -lat $f | cut -d" " -f5)
        arch=${f/.\//}
        arch=${arch/$1.tar.xz/}
        echo \"${filesize}${arch}${shahash}\",
    done
    echo
}

set +x
printpackages _bitcoin
printpackages _bitcoinknots
printpackages _liquid
