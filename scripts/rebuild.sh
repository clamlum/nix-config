#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<EOF
Usage:
  $(basename "$0") [OPTIONS]
  $(basename "$0") [OPTIONS] -i INPUT [INPUT ...]

Description:
  Rebuild this Nix system, optionally updating the flake or selected flake inputs first.

Arguments:
  INPUT           Flake input to update when -i is passed.

Options:
  -u              Update the entire flake ('git pull' + 'nix flake update') before rebuilding.
  -i              Update only the specified trailing INPUT arguments before rebuilding.
  -g              Run garbage collection after rebuilding.
  -f FLAKE        Override the flake path (default: $HOME/nix-config).
  -a ACTION       Rebuild action to run (default: switch).
  -o OUTPUT       Override flake output (default: current hostname).
  --help          Show this help and exit.

Notes:
  - '-u' and '-i' are mutually exclusive.
  - INPUT arguments are only valid when '-i' is passed.
  - Options must come before INPUT arguments.

Examples:
  $(basename "$0")
  $(basename "$0") -u
  $(basename "$0") -a switch -g
  $(basename "$0") -i nixpkgs home-manager
  $(basename "$0") -a switch -o desktop -i nixpkgs home-manager
EOF
}

for arg in "$@"; do
    if [[ "$arg" == "--help" ]]; then
        usage
        exit 0
    fi
done

UPGRADE=0
UPDATE_INPUTS=0
GC=0
FLAKE="$HOME/nix-config"
ACTION="switch"
OUTPUT=$(hostname)
OS="$(uname -s)"

while getopts ":huigf:a:o:" opt; do
    case "$opt" in
        h)
            usage
            exit 0
            ;;
        u) UPGRADE=1 ;;
        i) UPDATE_INPUTS=1 ;;
        g) GC=1 ;;
        f) FLAKE="$OPTARG" ;;
        a) ACTION="$OPTARG" ;;
        o) OUTPUT="$OPTARG" ;;
        :)
            echo "Error: -$OPTARG requires an argument"
            usage
            exit 2
            ;;
        \?)
            echo "Unknown flag: -$OPTARG"
            usage
            exit 2
            ;;
    esac
done
shift $((OPTIND - 1))
INPUTS=("$@")

if [[ "$UPGRADE" -eq 1 && "$UPDATE_INPUTS" -eq 1 ]]; then
    echo "Error: -u and -i are mutually exclusive"
    usage
    exit 2
fi

if [[ "$UPDATE_INPUTS" -eq 1 && ${#INPUTS[@]} -eq 0 ]]; then
    echo "Error: -i requires at least one input"
    usage
    exit 2
fi

if [[ "$UPDATE_INPUTS" -eq 0 && ${#INPUTS[@]} -gt 0 ]]; then
    echo "Error: input arguments require -i"
    usage
    exit 2
fi

if [[ "$UPGRADE" -eq 1 ]]; then
    echo "==> Updating $FLAKE"
    cd "$FLAKE"
    git pull
    echo "==> Updating flake in $FLAKE"
    nix flake update
    echo "==> Flake update complete"
elif [[ "$UPDATE_INPUTS" -eq 1 ]]; then
    echo "==> Updating flake inputs '${INPUTS[*]}' in $FLAKE"
    cd "$FLAKE"
    nix flake update "${INPUTS[@]}"
    echo "==> Flake input update complete"
fi

case "$OS" in
    Darwin)
        echo "==> Running on macOS"
        OUTPUT="macbook"
        COMMAND="darwin-rebuild"
        ;;
    Linux)
        echo "==> Running on Linux"
        COMMAND="nixos-rebuild"
        ;;
    *)
        echo "Unknown OS: $OS"
        exit 1
        ;;
esac

echo "Using output: $OUTPUT"

sudo true

rebuild_start=$(date +%s)
if $COMMAND $ACTION --flake "$FLAKE#$OUTPUT" --sudo; then
    rebuild_elapsed=$(( $(date +%s) - rebuild_start ))
    echo "==> Rebuild/$ACTION complete in $(( rebuild_elapsed / 60 ))m $(( rebuild_elapsed % 60 ))s"
else
    echo "Error: $COMMAND failed"
    exit 1
fi

if [[ "$GC" -eq 1 ]]; then
    echo "==> Running garbage collection"
    sudo nix-collect-garbage -d 2>/dev/null | tail -n 1
    nix-collect-garbage -d 2>/dev/null | tail -n 1
    echo "==> Garbage collection complete"
fi
