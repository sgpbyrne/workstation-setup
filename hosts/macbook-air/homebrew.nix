{ ... }:

{
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    taps = [
      "nikitabobko/tap"
    ];

    casks = [
      "ghostty"
      "nikitabobko/tap/aerospace"
      "raycast"
      "orbstack"
      "1password"
      "obsidian"
    ];

    brews = [
      "azure-cli"
    ];

    global.autoUpdate = false;
  };
}
