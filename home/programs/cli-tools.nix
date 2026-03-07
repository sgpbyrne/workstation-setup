{ pkgs, ... }:

{
  # Tools with home-manager program modules
  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Mocha";
      style = "numbers,changes,header";
    };
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin_mocha";
      theme_background = false;
    };
  };

  programs.k9s = {
    enable = true;
    settings = {
      k9s = {
        ui = {
          skin = "catppuccin-mocha";
        };
      };
    };
  };

  # Tools installed as packages
  home.packages = with pkgs; [
    # Modern CLI replacements
    ripgrep
    fd
    dust
    tealdeer
    yq-go
    jq
    yazi

    # System utilities
    tree
    watch
    curl
    wget
    unzip
    gnused
    coreutils

    # Development
    go
    nodejs_22
    python313
    uv
    jdk17
    gradle

    # Nerd Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];
}
