# Every task, per ADR-0103. A recipe that calls a tool runs only inside the dev shell of flake.nix.

set shell := ["bash", "-euo", "pipefail", "-c"]

import? 'template/justfile'

# List the recipes
default:
    @just --list

mago := "mago --config .config/mago.toml"

# Install the dependencies from composer.lock
setup: in-shell
    composer install --no-interaction --prefer-dist

# Run the greeting command
[positional-arguments]
run *args: in-shell
    php bin/greet.php "$@"

# Apply every formatter
format: in-shell
    {{ mago }} lint --fix
    {{ mago }} format
    rumdl check --fix .
    nixfmt $(git ls-files '*.nix')
    dprint fmt
    just --fmt

# Check the Composer lock, PHP format, lint rules, and types
lint-php: in-shell
    composer validate --strict
    composer check-platform-reqs --lock
    {{ mago }} format --check
    {{ mago }} lint
    {{ mago }} analyze

# Prose, comments, and ADRs, per ADR-0001
lint-prose: in-shell
    tabkit check

# Markdown structure and formatting, per ADR-0001
lint-md: in-shell
    rumdl check .

# Scan the working tree for committed secrets
lint-secrets: in-shell
    gitleaks dir . --no-banner

# JSON, JSONC, TOML, and YAML format, per ADR-0104
lint-data: in-shell
    dprint check

# Nix format, per ADR-0104
lint-nix: in-shell
    nixfmt --check $(git ls-files '*.nix')

# justfile format, per ADR-0104
lint-just:
    just --fmt --check

# Run every linter
lint: lint-php lint-prose lint-md lint-secrets lint-data lint-nix lint-just

# Run the tests
test: in-shell
    php vendor/bin/phpunit --bootstrap vendor/autoload.php tests

# The fast gate: run it before you finish a change
check: lint test

# Run exactly what CI runs: every check of flake.nix, in the Nix sandbox
ci:
    nix flake check --print-build-logs

# Push what CI built to the binary cache, per ADR-0101. Without NIX_CACHE_URL it does nothing
cache-push: in-shell
    nix-cache-push

# Run Renovate over this repository, per ADR-0102. The renovate workflow calls it
ci-renovate: in-shell
    nix run --inputs-from . nixpkgs#renovate

# Refresh the Nix vendor hash after a Composer lock or toolchain change
deps-sync: in-shell
    #!/usr/bin/env bash
    set -euo pipefail
    hash_file=nix/composer-vendor-hash
    probe=$(nix eval --raw .#composer-vendor --apply '
      vendor: (vendor.overrideAttrs (_: {
        outputHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      })).drvPath
    ')
    build_log=$(nix build --no-link "$probe^*" 2>&1) || true
    hash=$(sed -nE 's/^[[:space:]]*got:[[:space:]]+(sha256-[A-Za-z0-9+/=]+)[[:space:]]*$/\1/p' <<< "$build_log")
    if [[ ! "$hash" =~ ^sha256-[A-Za-z0-9+/]{43}=$ ]]; then
      printf '%s\n' "$build_log" >&2
      exit 1
    fi
    if [[ "$hash" != "$(cat "$hash_file")" ]]; then
      temp_hash=$(mktemp "$hash_file.XXXXXX")
      trap 'rm -f "$temp_hash"' EXIT
      printf '%s\n' "$hash" > "$temp_hash"
      chmod 644 "$temp_hash"
      mv "$temp_hash" "$hash_file"
    fi

[private]
in-shell:
    @test -n "${IN_NIX_SHELL:-}" || { echo "Enter the dev shell first: run nix develop, or allow direnv." >&2; exit 1; }
