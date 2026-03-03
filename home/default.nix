{ pkgs, lib, inputs, username, ... }:

{
  imports = [
    ./programs.nix
  ];

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
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
