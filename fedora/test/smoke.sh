#!/usr/bin/env bash
# Smoke test for a ci-fedora image. Runs inside the image as user regolith:
#   docker run --rm -v "$PWD/fedora/test:/test:ro" ci-fedora:<release>-<arch> /test/smoke.sh
# With MOCK=1 (and optionally MOCK_CONFIG) it also builds the test package in mock and
# reports which mock isolation mode works. mock needs a --privileged container; there,
# --isolation=simple works (see the wiki's Fedora RPM build tooling page).
# hello.spec uses only dictionary words: rpmlint reports unknown words as errors.
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
spec="$here/hello.spec"

echo "== image"
cat /etc/os-release | grep -E '^(NAME|VERSION_ID)='
id

echo "== tools"
rpmbuild --version
mock --version
rpmlint --version

echo "== rpmlint"
rpmlint "$spec"

echo "== sudo dnf install"
sudo dnf -y -q install hello
hello --version | head -1

echo "== rpmbuild -ba"
rpmdev-setuptree
rpmbuild -ba "$spec"
ls ~/rpmbuild/RPMS/noarch/ ~/rpmbuild/SRPMS/

if [ "${MOCK:-0}" = "1" ]; then
  config="${MOCK_CONFIG:-fedora-$(rpm -E %fedora)-$(uname -m)}"   # fedora-rawhide-<arch> for Rawhide
  srpm="$(ls ~/rpmbuild/SRPMS/*.src.rpm)"
  for isolation in simple nspawn; do
    echo "== mock --isolation=$isolation -r $config"
    if mock --isolation="$isolation" -r "$config" --rebuild "$srpm" --resultdir /tmp/mock-"$isolation"; then
      echo "MOCK_ISOLATION_OK=$isolation"
      break
    fi
    echo "MOCK_ISOLATION_FAILED=$isolation"
  done
fi

echo "== smoke test passed"
