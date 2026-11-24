# PHP Template

A base for PHP command-line projects and packages. A small greeting command shows how to load and test code with Composer.

## Stack

| Tool | Owns |
| --- | --- |
| [PHP](https://www.php.net/) | The PHP 8.5 runtime |
| [Composer](https://getcomposer.org/) | Package dependencies, the lock file, and PSR-4 class loading |
| [Mago](https://mago.carthage.software/) | PHP format, lint, and type checks |
| [PHPUnit](https://phpunit.de/) | Unit tests |
| [Phpactor](https://phpactor.readthedocs.io/) | The PHP language server for Zed |
| [Nix](https://nixos.org/) and [tabkit](https://github.com/tabmadi/tabkit) | The pinned dev shell, git hooks, and sandboxed checks |
| [just](https://just.systems/) | The tasks that run the tools |
| [Renovate](https://docs.renovatebot.com/) | Updates to the pinned dependencies and tools |

## Getting started

Install [Nix](https://nixos.org/download/) with flakes enabled. In the repo, enter the dev shell and install the dependencies.

```bash
nix develop
just setup
just run "Grace Hopper"
```

The command prints `Hello, Grace Hopper!`. Run `just run` to use the default name.

## Editor

Install the PHP extension in [Zed](https://zed.dev/). Install [direnv](https://direnv.net/) with [nix-direnv](https://github.com/nix-community/nix-direnv), then run `direnv allow`. Zed loads Phpactor and Mago from the dev shell. It uses the same Mago config as `just format`.

## Tasks

| Task | Does |
| --- | --- |
| `just setup` | Installs packages from `composer.lock` |
| `just run [name]` | Runs the greeting command |
| `just format` | Applies format and safe lint fixes |
| `just lint` | Checks Composer, PHP, and the shared file types |
| `just test` | Runs the PHPUnit tests |
| `just check` | Runs lint and tests with the local dependencies |
| `just ci` | Runs the same Nix checks as CI and the git pre-push hook |
| `just deps-sync` | Refreshes the Nix vendor hash after a dependency or toolchain change |

## Layout

| Path | Holds |
| --- | --- |
| `bin/greet.php` | The command entry point |
| `src/` | PHP classes that Composer loads |
| `tests/` | PHPUnit tests |
| `composer.json`, `composer.lock` | The project manifest and exact PHP package versions |
| `.config/mago.toml` | PHP source paths and checks |
| `flake.nix`, `flake.lock` | The dev shell, hooks, checks, and pinned inputs |
| `nix/composer-vendor-hash` | The hash of the locked dependencies that Nix fetches |
| `docs/adr/` | The project decisions |
| `template/` | The template contract, checks, and copy steps |

## Starting a project

Make a new project with Nix. It copies the project files and omits the template scope.

```bash
nix flake new -t github:tabmadi/php-template my-project
cd my-project
git init
git add -A
nix develop
just setup
```

1. Set your package name and description in `composer.json`. If you change the `App` namespace, update the Composer mapping and the PHP files together.
2. Run `composer update --lock` and `just deps-sync` after the manifest change. Keep the lock and vendor hash in the same commit.
3. Replace the sample command and tests with your code. Update the Mago source paths if your layout changes.
4. Rewrite this README for your project. Update the contacts in `.github/SECURITY.md` and the copyright line in `LICENSE`.
5. Remove the setup line from `AGENTS.md`.
6. Set GitHub to squash merge with the pull request title and an empty message body. Add the `RENOVATE_TOKEN` repository secret for dependency updates.

### With the GitHub template button

Clone the new repository and run `nix develop`. Run `just init` to remove the template scope and the setup line from `AGENTS.md`.

Follow the project steps above and skip the step on `AGENTS.md`. Give the initial commit a Conventional Commits title when you set up the new repository.

## Decisions

See the [ADR index](docs/adr/README.md) for the tool choices, the options we compared, and the rules.

## Contributing

Run `just format` and `just check` before a change. Run `just ci` to check the full Nix gate.

## Security

See the [security policy](.github/SECURITY.md).

## License

See [LICENSE](LICENSE).
