# Architecture Decision Records

Each ADR has a one-sentence **Decides** line and ends with a flat **Rules** section. This table lists the Decides line of every ADR.

| ADR | Decides |
| --- | --- |
| [0000](0000-foundations.md) | What this repo is, the recipe contract, the shape of an ADR and how it compares options, and the license |
| [0001](0001-documentation-conventions.md) | The house style for every text in the repo: Simple English on the ASD-STE100 model |
| [0100](0100-toolchain.md) | Nix with flakes pins every tool and runs every check through tabkit, with the tools on `nixpkgs-unstable` and NixOS machines on stable NixOS |
| [0101](0101-source-control-and-ci.md) | The git hooks, the commit convention and its check, the secret scan, and the CI gate |
| [0102](0102-dependency-updates.md) | Renovate proposes every update to `flake.lock`, the language lock files, and the GitHub Actions, and the CI gate decides |
| [0103](0103-tasks.md) | `just` runs every task, and the recipe names `setup`, `format`, `lint`, `test`, `check`, and `ci` are a contract |
| [0104](0104-formatters-and-linters.md) | One formatter for each tracked file type, each with a check, and every tool config in `.config/` |
| [0105](0105-editor.md) | Zed is the supported editor, with committed project settings, and no check depends on an editor |
| [0110](0110-php.md) | The dev shell and checks use PHP 8.5 from the pinned Nix input |
| [0111](0111-composer.md) | Composer owns the PHP lock and class loading, and Nix uses its fixed hash vendor builder for the checks |
| [0112](0112-php-quality.md) | Mago formats, lints, and checks types in the PHP source |
| [0113](0113-tests.md) | PHPUnit runs the unit tests as a locked development dependency |
| [0114](0114-php-editor.md) | The dev shell provides Phpactor to Zed, and Mago formats PHP on save |
| [0115](0115-web-framework.md) | The PHP starter uses the PHP runtime and Composer as its application base |

A new ADR starts from [`_template.md`](_template.md).
