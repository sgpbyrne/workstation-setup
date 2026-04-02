{
  pkgs,
  lib,
  self,
  username,
  hostname,
  ...
}:

{
  imports = [
    ./homebrew.nix
  ];

  # Nix is managed by the Determinate Systems installer
  nix.enable = false;

  # System
  system = {
    stateVersion = 6;
    configurationRevision = if self ? rev then self.rev else null;
  };

  nixpkgs.config.allowUnfree = true;

  # System-level packages
  environment.systemPackages = with pkgs; [
    vim
  ];

  # Enable Zsh as system shell
  programs.zsh.enable = true;

  # User account
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  # Primary user (required for per-user settings like homebrew, system.defaults)
  system.primaryUser = username;

  # Networking
  networking.hostName = hostname;

  # Extract macOS Keychain certs so Nix-installed tools trust corporate proxy CAs
  system.activationScripts.postActivation.text = ''
    echo "extracting macOS Keychain certificates..."
    mkdir -p /etc/ssl/certs
    /usr/bin/security find-certificate -a -p /Library/Keychains/System.keychain > /etc/ssl/certs/keychain-ca-certs.pem 2>/dev/null || true
    /usr/bin/security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain >> /etc/ssl/certs/keychain-ca-certs.pem 2>/dev/null || true
    cat ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/keychain-ca-certs.pem > /etc/ssl/certs/ca-certificates.crt 2>/dev/null || true

    # Write Firefox policies (must run after Homebrew installs Firefox)
    if [ -d "/Applications/Firefox.app" ]; then
      echo "configuring Firefox policies..."
      mkdir -p "/Applications/Firefox.app/Contents/Resources/distribution"
      cat > "/Applications/Firefox.app/Contents/Resources/distribution/policies.json" << 'FIREFOXEOF'
${builtins.readFile ../../home/programs/firefox-policies.json}
FIREFOXEOF
    fi
  '';

  # Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # Fix Ghostty xterm-ghostty TERM issues with sudo
  security.sudo.extraConfig = ''
    Defaults env_keep += "TERMINFO"
  '';

  # macOS system preferences
  system.defaults = {
    dock = {
      autohide = false;
      mru-spaces = false;
      show-recents = false;
      tilesize = 48;
    };

    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv";
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleInterfaceStyle = "Dark";
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };

    CustomUserPreferences = {
      "com.apple.screencapture" = {
        location = "~/Desktop/Screenshots";
        type = "png";
      };
    };
  };

  # Keyboard
  system.keyboard = {
    enableKeyMapping = true;
  };
}
