# ADR-0112: PHP format, lint, and types

- **Status:** Accepted
- **Decides:** Mago formats, lints, and checks types in the PHP source.

## Context

The project needs a formatter that the editor can run and checks that report mistakes before the code runs.

## Decision drivers

1. **Style.** The formatter supports common PHP style and can check files in CI.
2. **Type checks.** The tools find type errors without running the app.
3. **Tool count.** Fewer commands and configs make the editor and CI easier to keep in step.
4. **Extension fit.** A project can add checks for its libraries or framework when it needs them.

## Considered options

| Option | 1 Style | 2 Type checks | 3 Tool count | 4 Extension fit | Verdict |
| --- | --- | --- | --- | --- | --- |
| Pint and PHPStan | Pint ships PER and Laravel presets and has a check mode | PHPStan has strict levels and PHPDoc type checks | Two tools and two configs | PHPStan has a large set of extensions, including Larastan | Good for a Laravel project or one that needs a PHPStan extension |
| PHP CS Fixer and Psalm | PHP CS Fixer offers named standards and detailed rule control | Psalm has strict levels and tracks untrusted data | Two tools and two configs | Psalm offers plugins, and PHP CS Fixer supports custom rules | Good when a project needs those checks or precise style control |
| PHP_CodeSniffer and PHPStan | PHPCS checks standards and PHPCBF fixes supported findings | PHPStan checks types | Two packages and three commands | Custom sniffs and PHPStan extensions | Good for a project with an existing set of sniffs |
| **Mago** | Default PER-CS style, editor input, and a CI check mode | Its analyzer checks PHP and PHPDoc types | One pinned binary and one config for three jobs | Includes linter rules and supports analyzer extensions | **Chosen for the plain PHP project** |

### Sources

- [PER Coding Style](https://www.php-fig.org/per/coding-style/), [Pint presets and checks](https://laravel.com/docs/13.x/pint), and [PHP CS Fixer CLI](https://cs.symfony.com/doc/usage.html).
- [PHP_CodeSniffer](https://github.com/PHPCSStandards/PHP_CodeSniffer), [PHPStan levels](https://phpstan.org/user-guide/rule-levels), and [PHPStan extensions](https://phpstan.org/user-guide/extension-library).
- [Psalm levels](https://psalm.dev/docs/running_psalm/error_levels/), [Psalm security analysis](https://psalm.dev/docs/security_analysis/), and [Larastan](https://github.com/larastan/larastan).
- [Mago formatter](https://mago.carthage.software/1.59.0/en/tools/formatter/configuration-reference/), [Mago analyzer](https://mago.carthage.software/1.59.0/en/tools/analyzer/overview/), and [Mago extensions](https://mago.carthage.software/1.59.0/en/extensions/getting-started/).

## Decision

Mago applies its default PER-CS style and checks the command, source, and tests. It reads dependency types from `vendor/`.

Mago, Pint with PER, and PHP CS Fixer with PER-CS each flag the same one-line function that needs formatting on PHP 8.5.

Mago and PHPStan level 10 both pass on the sample and both catch a wrong return type in a small probe. This comparison covers that case only.

Mago serves three jobs with one config and no framework-specific rules. The PHP rules stay in `.config/mago.toml`.

## Consequences

Projects that depend on a framework extension should compare the checkers against that code. The starter uses the built-in rules with no baseline.

## Rules

- Mago is the PHP formatter in the editor, the hook, and the tasks. `(CI: lint-php)`
- The gate runs Mago format checks, lint, and analysis. `(CI: lint-php)`
