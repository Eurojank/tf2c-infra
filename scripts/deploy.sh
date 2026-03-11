#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FLAKE_ROOT="$PROJECT_ROOT/nixos"

source "$PROJECT_ROOT/.env"

TARGET="${SSH_USER}@${SSH_HOST}"

echo "==> building locally"
TOPLEVEL="$(nix build "${FLAKE_ROOT}#nixosConfigurations.${NIXOS_HOSTNAME}.config.system.build.toplevel" --print-out-paths)"
[[ -z "$TOPLEVEL" ]] && { echo "build failed: empty toplevel"; exit 1; }

echo "==> current remote system"
OLD_SYSTEM="$(ssh "$TARGET" "readlink -f /run/current-system")"

echo "==> copying closure"
nix copy --to "ssh://$TARGET" "$TOPLEVEL"

echo "==> test activation"
ssh "$TARGET" "sudo -n $TOPLEVEL/bin/switch-to-configuration test"

echo "==> health check"
if timeout 30 ssh "$TARGET" "$HEALTHCHECK_CMD"; then
    echo "==> committing generation"
    ssh "$TARGET" "sudo -n nix-env -p /nix/var/nix/profiles/system --set $TOPLEVEL"

    echo "==> switching permanently"
    ssh "$TARGET" "sudo -n $TOPLEVEL/bin/switch-to-configuration switch"

    echo "==> updating bootloader"
    ssh "$TARGET" "sudo -n $TOPLEVEL/bin/switch-to-configuration boot"

    echo "deploy complete"
else
    echo "health check failed, rolling back"
    ssh "$TARGET" "sudo -n $OLD_SYSTEM/bin/switch-to-configuration switch"
    exit 1
fi