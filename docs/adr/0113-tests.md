# ADR-0113: PHP tests

- **Status:** Accepted
- **Decides:** PHPUnit runs the unit tests as a locked development dependency.

## Context

The project needs a runner for a small unit test suite with room to add tests as the code grows.

## Decision drivers

1. **Core tests.** The runner supports assertions, data sets, and test doubles.
2. **Setup cost.** A small suite needs little configuration and runs offline.
3. **Growth.** A project can use the same test runner as its suite grows.

## Considered options

| Option | 1 Core tests | 2 Setup cost | 3 Growth | Verdict |
| --- | --- | --- | --- | --- |
| Native PHP assertions | Basic conditions | No dependencies, but assertion settings can disable the checks | The project builds its own runner and reports | Good for a short script check |
| Pest | PHPUnit assertions with function syntax and an expectation API | Adds a layer on PHPUnit | Good for expressive tests and plugins | Good if a team wants Pest syntax or plugins |
| Codeception | PHPUnit unit tests and module helpers | Adds suite and module setup | Good for shared acceptance and integration suites | Good if a project needs the modules |
| **PHPUnit 13** | Assertions, data providers, and test doubles | One Composer dependency and a command | Supports richer test configuration and reports | **Chosen** |

### Sources

- [PHP assert](https://www.php.net/manual/en/function.assert.php), [PHPUnit manual](https://docs.phpunit.de/en/13.4/), and [PHPUnit support table](https://phpunit.de/supported-versions.html).
- [Pest documentation](https://pestphp.com/docs/why-pest) and [Codeception unit tests](https://codeception.com/docs/UnitTests).

## Decision

PHPUnit 13 runs test classes in `tests/` and loads the project through the Composer autoloader. The command selects the bootstrap and the test folder.

## Consequences

Test code uses PHPUnit classes and assertions. A project can add PHP test config when it needs fixtures or more than one suite.

## Rules

- The local task and the sandbox run PHPUnit from the Composer lock. `(CI: test)`
- The sample tests run without an external service. `(CI: test)`
