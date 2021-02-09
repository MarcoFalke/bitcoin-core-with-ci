#!/usr/bin/env bash
#
# Copyright (c) 2020 The Bitcoin Core developers
# Distributed under the MIT software license, see the accompanying
# file COPYING or http://www.opensource.org/licenses/mit-license.php.

export LC_ALL=C.UTF-8

apt install software-properties-common wget -y
dpkg --add-architecture i386
wget -nc https://dl.winehq.org/wine-builds/winehq.key
apt-key add winehq.key
add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
apt install --no-install-recommends  winehq-stable

for b_name in {"${BASE_OUTDIR}/bin"/*,src/secp256k1/*tests,src/univalue/{no_nul,test_json,unitester,object}}.exe; do
    # shellcheck disable=SC2044
    for b in $(find "${BASE_ROOT_DIR}" -executable -type f -name "$(basename $b_name)"); do
      if (file "$b" | grep "Windows"); then
        echo "Wrap $b ..."
        mv "$b" "${b}_orig"
        echo '#!/usr/bin/env bash' > "$b"
        echo "wine \"${b}_orig\" \"\$@\"" >> "$b"
        chmod +x "$b"
      fi
    done
done
