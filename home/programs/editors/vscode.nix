{ pkgs, inputs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
      extensions = with pkgs.vscode-marketplace; [
        # Go
        golang.go

        # Terraform
        hashicorp.terraform

        # Python
        ms-python.python
        ms-python.vscode-pylance

        # Nix
        jnoortheen.nix-ide

        # Kubernetes
        ms-kubernetes-tools.vscode-kubernetes-tools

        # YAML / TOML
        redhat.vscode-yaml
        tamasfe.even-better-toml

        # Docker
        ms-azuretools.vscode-docker

        # Git
        eamodio.gitlens

        # Theme
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons

        # Editor enhancements
        esbenp.prettier-vscode
        dbaeumer.vscode-eslint
        editorconfig.editorconfig
        streetsidesoftware.code-spell-checker

        # Remote
        ms-vscode-remote.remote-containers

      ];

      userSettings = {
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'Fira Code', monospace";
        "editor.fontSize" = 14;
        "editor.fontLigatures" = true;
        "editor.formatOnSave" = true;
        "editor.minimap.enabled" = false;
        "editor.renderWhitespace" = "boundary";
        "editor.bracketPairColorization.enabled" = true;
        "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.iconTheme" = "catppuccin-mocha";
        "files.trimTrailingWhitespace" = true;
        "files.insertFinalNewline" = true;

        # Nix
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";

        # Go
        "go.useLanguageServer" = true;

        # Terraform
        "terraform.languageServer.enable" = true;
      };
    };
  };

  # Language servers (shared between VS Code and Neovim)
  home.packages = with pkgs; [
    nil
    nixfmt
    gopls
    terraform-ls
    pyright
    typescript-language-server
    lua-language-server
    yaml-language-server
  ];
}
