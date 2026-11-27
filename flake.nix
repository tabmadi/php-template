# The toolchain, the git hooks, and the checks, per ADR-0100. The tabkit module holds every shared part.
{
  description = "A PHP command-line project with Composer, Mago, and PHPUnit";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    # A new version is a new tag here.
    tabkit = {
      url = "github:tabmadi/tabkit/v0.29.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      # Only the own checks of tabkit read this input, so it adds no second nixpkgs here.
      inputs.nixos-stable.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, tabkit, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # The template scope adds its own checks and outputs. A copy has no template/ folder, so it adds nothing.
      imports = [
        tabkit.flakeModules.default
      ]
      ++ inputs.nixpkgs.lib.optional (builtins.pathExists ./template/scope.nix) ./template/scope.nix;

      perSystem =
        { pkgs, lib, ... }:
        let
          php = pkgs.php85;
          inherit (php.packages) composer;
          mago = "mago --config .config/mago.toml";
          composerVendor = php.mkComposerVendor {
            pname = "php-app";
            version = "0";
            src = lib.fileset.toSource {
              root = ./.;
              fileset = lib.fileset.unions [
                ./composer.json
                ./composer.lock
              ];
            };
            vendorHash = lib.removeSuffix "\n" (builtins.readFile ./nix/composer-vendor-hash);
            composerNoDev = false;
          };

          phpCheck =
            name: command:
            pkgs.runCommand name
              {
                nativeBuildInputs = [
                  php
                  composer
                  pkgs.mago
                ];
                COMPOSER_DISABLE_NETWORK = "1";
              }
              ''
                export HOME="$TMPDIR"
                cp -r ${./.} source
                chmod -R u+w source
                cd source
                cp -r --no-preserve=mode ${composerVendor}/vendor .
                composer install --no-plugins --no-scripts --no-interaction --no-progress
                ${command}
                touch "$out"
              '';
        in
        {
          tabkit.packages = [
            php
            composer
            pkgs.mago
            pkgs.phpactor
          ];

          tabkit.hooks.mago = {
            name = "mago format";
            entry = "${lib.getExe pkgs.mago} --config .config/mago.toml format";
            files = "\\.php$";
          };

          packages.composer-vendor = composerVendor;

          checks.lint-php = phpCheck "lint-php" ''
            composer validate --strict
            composer check-platform-reqs --lock
            ${mago} format --check
            ${mago} lint
            ${mago} analyze
          '';
          checks.test = phpCheck "test" ''
            php vendor/bin/phpunit --bootstrap vendor/autoload.php tests
          '';
        };
    };
}
