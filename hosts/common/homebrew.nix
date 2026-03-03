{ ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    global.autoUpdate = false;

    taps = [
      "nikitabobko/tap"
    ];

    casks = [
      "ghostty"
      "nikitabobko/tap/aerospace"
      "raycast"
      "orbstack"
      "1password"
    ];

    brews = [
      "azure-cli"
    ];
  };
}
