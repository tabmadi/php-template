# The template scope, per TPL-0000. The template module of tabkit adds the lint-scope check and the templates output.
{ inputs, ... }:
{
  imports = [ inputs.tabkit.flakeModules.template ];

  tabkit.template = {
    extraVoice = [
      "github\\.com/tabmadi"
      "blueprints"
    ];
    description = "A PHP command-line project with Composer, Mago, and PHPUnit";
    welcomeText = ''
      # A new project

      Follow `Starting a project` in `README.md`.
    '';
  };
}
