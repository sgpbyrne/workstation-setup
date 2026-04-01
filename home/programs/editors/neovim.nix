{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # LazyVim Lua config as dotfiles
  xdg.configFile."nvim" = {
    source = ../../../dotfiles/nvim;
    recursive = true;
  };

  # External tools that LazyVim expects
  home.packages = with pkgs; [
    # Formatters
    stylua
    black
    ruff
    gofumpt
    golines
    shfmt
    prettier

    # Linters
    shellcheck

    # Build dependencies for treesitter
    gcc
  ];
}
