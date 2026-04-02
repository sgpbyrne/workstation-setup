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
      "firefox"
      "ghostty"
      "nikitabobko/tap/aerospace"
      "raycast"
      "orbstack"
    ];

    brews = [
      "azure-cli"
    ];
  };
}
