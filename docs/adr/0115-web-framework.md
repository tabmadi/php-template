# ADR-0115: Web framework

- **Status:** Accepted
- **Decides:** The PHP starter uses the PHP runtime and Composer as its application base.

## Context

The starter serves command-line projects and packages. A web project also needs choices about HTTP and application services.

## Decision drivers

1. **Entry points.** A command or package can run without a framework boot step.
2. **HTTP needs.** The option can supply routing and middleware when a project needs them.
3. **App services.** A web app can get validation, storage, or authentication from the stack.

## Considered options

| Option | 1 Entry points | 2 HTTP needs | 3 App services | Verdict |
| --- | --- | --- | --- | --- |
| Laravel | Artisan supports commands in a Laravel app | Routes and middleware come with the framework | First-party services and a choice of starter kits | Good for an integrated web app |
| Symfony | Symfony Console can run as a stand-alone package | Framework and components cover full apps and smaller uses | Components and bundles can be chosen to fit the project | Good when a project wants a modular set of web components |
| Slim | A small HTTP framework leaves CLI choices to the project | Router and PSR middleware are its main role | A project chooses extra packages | Good for a narrow HTTP service |
| **PHP and Composer** | The command runs directly and libraries load with PSR-4 | A project adds HTTP tools if it needs them | A project chooses its own packages | **Chosen for this starter** |

### Sources

- [Laravel routing](https://laravel.com/docs/13.x/routing), [Laravel Artisan](https://laravel.com/docs/13.x/artisan), and [Laravel starter kits](https://laravel.com/docs/13.x/starter-kits).
- [Symfony setup](https://symfony.com/doc/current/setup.html), [Symfony Console](https://symfony.com/doc/current/components/console.html), and [Slim documentation](https://www.slimframework.com/docs/v4/).
- [Composer autoloading](https://getcomposer.org/doc/01-basic-usage.md#autoloading).

## Decision

Composer loads the sample code, and PHP runs the command directly. The project scope fits a package or CLI application.

## Consequences

Each web project chooses its own framework and records the reason against its HTTP and application needs.

## Rules

- The sample command starts from the Composer autoloader and a PHP entry point.
