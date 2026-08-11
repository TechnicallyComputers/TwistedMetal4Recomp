#!/usr/bin/env bash
# Stage a playable netplay/dev install next to CI / retcomm release layout.
#
# Runtime resolves bios/openbios.bin beside the executable (not
# psxrecomp/bios/). CMake POST_BUILD already stages that unit under
# build-release/bios/ — this script copies it into dist/ so binary-only
# syncs do not drop OpenBIOS.
#
# Usage:
#   scripts/stage_playable_dist.sh [build-dir] [dest-dir]
# Defaults:
#   build-dir = <repo>/build-release
#   dest-dir  = <repo>/dist/tm4
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="${1:-${ROOT}/build-release}"
DEST="${2:-${ROOT}/dist/tm4}"
BIN_NAME="TwistedMetal4_Recompiled"

die() { echo "stage_playable_dist: ERROR: $*" >&2; exit 1; }
note() { echo "stage_playable_dist: $*"; }

[[ -d "${BUILD}" ]] || die "build dir missing: ${BUILD}"
[[ -f "${BUILD}/${BIN_NAME}" ]] || die "binary missing: ${BUILD}/${BIN_NAME}"
[[ -f "${BUILD}/bios/openbios.bin" ]] || die \
  "bundled OpenBIOS missing next to binary: ${BUILD}/bios/openbios.bin
  (rebuild TwistedMetal4_Recompiled so POST_BUILD stages bios/)"

mkdir -p "${DEST}"
cp -a "${BUILD}/${BIN_NAME}" "${DEST}/${BIN_NAME}"

# Prefer CMake-staged bios/ (openbios.bin + MIT notice only).
rm -rf "${DEST}/bios"
mkdir -p "${DEST}/bios"
cp -a "${BUILD}/bios/openbios.bin" "${DEST}/bios/openbios.bin"
if [[ -f "${BUILD}/bios/OpenBIOS.LICENSE" ]]; then
  cp -a "${BUILD}/bios/OpenBIOS.LICENSE" "${DEST}/bios/OpenBIOS.LICENSE"
elif [[ -f "${ROOT}/psxrecomp/bios/OpenBIOS.LICENSE" ]]; then
  cp -a "${ROOT}/psxrecomp/bios/OpenBIOS.LICENSE" "${DEST}/bios/OpenBIOS.LICENSE"
fi

if [[ -d "${BUILD}/assets" ]]; then
  rm -rf "${DEST}/assets"
  cp -a "${BUILD}/assets" "${DEST}/assets"
fi

for f in game.toml VERSION keybinds.ini README.md README-SETUP.txt; do
  if [[ -f "${ROOT}/${f}" ]]; then
    cp -a "${ROOT}/${f}" "${DEST}/${f}"
  elif [[ -f "${BUILD}/${f}" ]]; then
    cp -a "${BUILD}/${f}" "${DEST}/${f}"
  fi
done

[[ -f "${DEST}/bios/openbios.bin" ]] || die "failed to stage bios/openbios.bin"
note "ok → ${DEST}"
note "  ${BIN_NAME} + bios/openbios.bin ($(stat -c%s "${DEST}/bios/openbios.bin") bytes)"
note "Sync this tree (or at least ${BIN_NAME} + bios/) to guest installs."
