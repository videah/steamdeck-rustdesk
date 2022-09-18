#!/usr/bin/env bash

set -euo pipefail

dir="$(mktemp -d)"
pushd .
cd "${dir}"

version="1.1.8"

wget -O rustdesk.tar.zst "https://github.com/rustdesk/rustdesk/releases/download/${version}/rustdesk-${version}-manjaro-arch.pkg.tar.zst"

mkdir -p rustdesk/usr/{bin,share,lib/{systemd/system,extension-release.d}}
unzstd rustdesk.tar.zst
tar xvf rustdesk.tar

cp -vrf usr rustdesk
cp -vrf usr/share/rustdesk/files/rustdesk.service rustdesk/usr/lib/systemd/system/rustdesk.service

source /etc/os-release
echo -e "SYSEXT_LEVEL=1.0\nID=steamos\nVERSION_ID=${VERSION_ID}" >> rustdesk/usr/lib/extension-release.d/extension-release.rustdesk

mkdir -p /var/lib/extensions
rm -rf /var/lib/extensions/rustdesk
cp -vrf rustdesk /var/lib/extensions/

popd
rm -rf "${dir}"