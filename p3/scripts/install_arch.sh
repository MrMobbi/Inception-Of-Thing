#!/usr/bin/env bash
set -Eeuo pipefail

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[0;33m'
readonly RESET='\033[0m'

info() {
    printf '%b==> %s%b\n' "$BLUE" "$1" "$RESET"
}

success() {
    printf '%b==> %s%b\n' "$GREEN" "$1" "$RESET"
}

warning() {
    printf '%b==> %s%b\n' "$YELLOW" "$1" "$RESET"
}

error() {
    printf '%bError: %s%b\n' "$RED" "$1" "$RESET" >&2
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

if [[ ! -r /etc/os-release ]]; then
    error "Cannot identify the operating system."
    exit 1
fi

# shellcheck disable=SC1091
source /etc/os-release

if [[ "${ID:-}" != "arch" && "${ID_LIKE:-}" != *"arch"* ]]; then
    error "This installer is intended for Arch Linux or an Arch-based distribution."
    exit 1
fi

if [[ $EUID -eq 0 ]]; then
    error "Do not run this script with sudo."
    echo "Run: make install"
    exit 1
fi

info "Updating package database and installing dependencies"

sudo pacman -Syu --needed --noconfirm \
    base-devel \
    ca-certificates \
    curl \
    docker \
    git \
    kubectl \
    make \
    openssl

success "Pacman dependencies installed"

info "Enabling Docker"

sudo systemctl enable --now docker.service

if ! docker info >/dev/null 2>&1; then
    if id -nG "$USER" | grep -qw docker; then
        warning "Your user belongs to the docker group, but the current session has not reloaded it."
        warning "Log out and back in, or run: newgrp docker"
    else
        warning "Adding $USER to the docker group"
        sudo usermod -aG docker "$USER"
        warning "Log out and back in, or run: newgrp docker"
    fi
fi

if command_exists k3d; then
    success "k3d is already installed: $(k3d version | head -n1)"
else
    info "Installing k3d v5.8.3"

    tmp_install_script="$(mktemp)"
    trap 'rm -f "$tmp_install_script"' EXIT

    curl --fail --silent --show-error --location \
        https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh \
        --output "$tmp_install_script"

    TAG=v5.8.3 bash "$tmp_install_script"

    success "k3d installed"
fi

info "Checking required commands"

required_commands=(
    curl
    docker
    git
    k3d
    kubectl
    openssl
)

missing=0

for executable in "${required_commands[@]}"; do
    if command_exists "$executable"; then
        printf '  %-10s %bOK%b\n' "$executable" "$GREEN" "$RESET"
    else
        printf '  %-10s %bMISSING%b\n' "$executable" "$RED" "$RESET"
        missing=1
    fi
done

if (( missing != 0 )); then
    error "One or more required programs are unavailable."
    exit 1
fi
