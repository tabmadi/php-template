# ADR-0114: PHP editor support

- **Status:** Accepted
- **Decides:** The dev shell provides Phpactor to Zed, and Mago formats PHP on save.

## Context

The editor needs PHP completion and navigation. The editor format must agree with the task format, per [ADR-0105](0105-editor.md).

## Decision drivers

1. **Editing.** The server provides completion and navigation in PHP.
2. **Pin.** The project can use a server version from the dev shell.
3. **Access.** Core editing features are open and work without a license key.

## Considered options

| Option | 1 Editing | 2 Pin | 3 Access | Verdict |
| --- | --- | --- | --- | --- |
| Syntax support alone | Highlights syntax without language server features | Uses the editor extension | Open | Good for a minimal editor setup |
| Intelephense | PHP language server with free and paid features | Can be installed as a versioned Node package | Proprietary, with a license key for premium features | Good when a team depends on its features |
| **Phpactor** | Completion, navigation, and refactoring | Packaged at the same Nix pin and supported by Zed | Open, with no license key | **Chosen** |

### Sources

- [Zed PHP extension](https://zed.dev/docs/languages/php), [Phpactor features](https://phpactor.readthedocs.io/), and [Intelephense features and license](https://intelephense.com/).

## Decision

Zed uses Phpactor from the Nix dev shell. Mago receives the PHP buffer and the file path, with the same config as the PHP tasks.

## Consequences

Editor features are available after the PHP extension loads the dev shell. The project gate runs without Zed.

## Rules

- Zed formats PHP with Mago and the project config.
- No check depends on the editor.
