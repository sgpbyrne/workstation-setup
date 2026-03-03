{ pkgs, gitName, gitEmail, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = gitName;
        email = gitEmail;
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.autocrlf = "input";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      rerere.enabled = true;
    };

    ignores = [
      ".DS_Store"
      "*.swp"
      ".direnv/"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
      line-numbers = true;
      syntax-theme = "Catppuccin Mocha";
    };
  };

  programs.lazygit = {
    enable = true;
  };

  programs.gh = {
    enable = true;
  };
}
