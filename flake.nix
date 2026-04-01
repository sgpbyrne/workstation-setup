{
  description = "sgpbyrne workstation config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    mac-app-util.url = "github:hraban/mac-app-util";

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      nix-homebrew,
      mac-app-util,
      ...
    }:
    let
      hosts = import ./hosts-config.nix;

      mkDarwin =
        name:
        {
          hostname,
          username,
          gitName,
          gitEmail,
          hostDir,
          clusters ? [],
          system ? "aarch64-darwin",
        }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              self
              hostname
              username
              gitName
              gitEmail
              clusters
              ;
            configName = name;
          };
          modules = [
            hostDir

            # VS Code extensions overlay
            {
              nixpkgs.overlays = [
                inputs.nix-vscode-extensions.overlays.default
              ];
            }

            # Homebrew integration
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                user = username;
                autoMigrate = true;
              };
            }

            # Spotlight indexing for Nix-installed apps
            mac-app-util.darwinModules.default

            # Home Manager
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "hm-backup";
                users.${username} = import ./home;
                extraSpecialArgs = {
                  inherit
                    inputs
                    hostname
                    username
                    gitName
                    gitEmail
                    clusters
                    ;
                  configName = name;
                };
              };
            }
          ];
        };
    in
    {
      darwinConfigurations."personal-mac" = mkDarwin "personal-mac" hosts.personal-mac;
      darwinConfigurations."work-mac" = mkDarwin "work-mac" hosts.work-mac;
    };
}
