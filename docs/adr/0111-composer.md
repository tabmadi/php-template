# ADR-0111: Composer dependencies

- **Status:** Accepted
- **Decides:** Composer owns the PHP lock and class loading, and Nix uses its fixed hash vendor builder for the checks.

## Context

The dev shell and the sandboxed checks need the same PHP dependencies. The checks run without network access.

## Decision drivers

1. **One package lock.** The local tools and the checks resolve the same dependencies.
2. **Package metadata.** The project has normal PHP package metadata and PSR-4 class loading.
3. **Sandbox.** The checks receive the package contents as an input and run offline.
4. **Update cost.** Renovate can update the package versions and the Nix inputs.

## Considered options

| Option | 1 One package lock | 2 Package metadata | 3 Sandbox | 4 Update cost | Verdict |
| --- | --- | --- | --- | --- | --- |
| Composer install in each check | Yes | Yes | A clean sandbox cannot download packages | Low | Good for a CI job with network access |
| Nix packages for every PHP tool | Nix locks the tool versions | Composer can still load the app classes | Yes | Low for tools already in Nixpkgs | Good for tools outside the PHP package graph |
| Commit the Composer vendor tree | Yes | Yes | Yes | Each update adds a vendor diff to git | Good where a repo must retain a copy of dependencies |
| **Composer lock and Nix vendor builder** | Yes | Yes | Yes, with a fixed hash for the fetch | Renovate updates the lock and runs `just deps-sync` | **Chosen** |

### Sources

- [Composer basic usage](https://getcomposer.org/doc/01-basic-usage.md), [Composer commands](https://getcomposer.org/doc/03-cli.md), and [PSR-4](https://www.php-fig.org/psr/psr-4/).
- [Nixpkgs PHP builders](https://nixos.org/manual/nixpkgs/unstable/#sec-php) and [Renovate Composer manager](https://docs.renovatebot.com/modules/manager/composer/).

## Decision

Composer installs from `composer.lock` in the dev shell. The manifest maps `App` to `src/` with PSR-4.

Nix fetches the same locked packages with `php.mkComposerVendor`, with dev packages enabled. The check makes a writable copy, then Composer builds the autoloader offline.

The fixed hash is in `nix/composer-vendor-hash`. The Renovate workflow calls `just deps-sync` to refresh it, per [ADR-0102](0102-dependency-updates.md).

## Consequences

A lock change can also change the Nix vendor hash. A manifest change or a Nix update can affect that hash too.

Checks use the extension set of the pinned runtime. A new extension belongs in that runtime definition.

## Rules

- The project commits `composer.lock` and the matching Nix vendor hash. `(CI: lint-php)`
- The check installs no packages from the network. The fixed hash fetch provides its vendor input. `(CI: ci)`
- Composer only runs a plugin when the manifest allows it.
