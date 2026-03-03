{ pkgs, lib, inputs, ... }:

{
  imports = [
    ./programs.nix
  ];

  home = {
    username = "sgpbyrne";
    homeDirectory = "/Users/sgpbyrne";
    stateVersion = "24.11";
    packages = with pkgs; [ ];
  };

  # Ghostty config
  xdg.configFile."ghostty/config" = {
    source = ../dotfiles/ghostty/config;
  };

  # AeroSpace config
  home.file.".aerospace.toml" = {
    source = ../dotfiles/aerospace/.aerospace.toml;
  };

  programs.home-manager.enable = true;
}
