#!/usr/bin/env bash

set -xeuo pipefail

dnf_opts="--setopt=fastestmirror=True"

dnf config-manager setopt keepcache=1
trap 'dnf config-manager setopt keepcache=0' EXIT

( # install trivalent
# "borrowing" from https://github.com/tulilirockz/sysext-trivalent/blob/main/install-trivalent.sh
    curl -fLsS --retry 5 -o /etc/yum.repos.d/repo.secureblue.dev.secureblue.repo https://repo.secureblue.dev/secureblue.repo

    dnf --best --repo=secureblue -y install trivalent

    secureblue_gpg_key_path="$(dnf repo info secureblue --json | jq -r '.[0].gpg_key.[0]')"

    rpmkeys --import "${secureblue_gpg_key_path}"
)

( # stuff im taking from the secureblue project lol
    dnf -y copr enable secureblue/packages "fedora-43-$(arch)"
    dnf -y install $dnf_opts \
      hardened_malloc \
      no_rlimit_as \
      trivalent-subresource-filter
)

( # install fish!
    dnf -y install $dnf_opts fish
)

( # install podman compose lol
    dnf -y install $dnf_opts podman-compose
)

cp -avf "/ctx/files"/. /
