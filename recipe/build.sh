#!/usr/bin/env bash

set -euxo pipefail

${PYTHON} -m pip install . -vv

if [[ "${target_platform}" == "osx-arm64" ]]; then
    export npm_config_arch="arm64"
fi

# Don't use pre-built gyp packages
export npm_config_build_from_source=true

NPM_CONFIG_USERCONFIG=/tmp/nonexistentrc

pushd askbot/media
pnpm import
pnpm install --prod
pnpm licenses list --json | pnpm-licenses generate-disclaimer --json-input --output-file=ThirdPartyLicenses.txt
