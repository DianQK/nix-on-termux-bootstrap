#!/data/data/com.termux/files/usr/bin/bash

set -eu -o pipefail

if [[ -d "/nix" ]]; then
  echo "Already in the Nix environment"
fi

if [ -z "$USER" ]; then
  echo "The USER environment variable is not set."
fi

unset LD_LIBRARY_PATH
unset LD_PRELOAD

export GC_NPROCS=1
export IN_PROOT_NIX=1

export PROOT_TMP_DIR=$PREFIX/tmp
export PROOT_L2S_DIR=$PREFIX/.l2s

exec $PREFIX/bin/proot \
  --bind=/dev \
  --bind=/dev/urandom:/dev/random \
  --bind=/sys \
  -b $PREFIX/nix:/nix \
  -b $PREFIX/var:/var \
  -b $PREFIX/run:/run \
  -b $PREFIX/etc:/etc! \
  -b $PREFIX/tmp:/tmp \
  -b $PREFIX:/usr \
  -b $PREFIX/dev/shm:/dev/shm \
  --kill-on-exit \
  --link2symlink \
  --sysvipc \
  $PREFIX/bin/bash
