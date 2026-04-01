# Workstation Setup

Nix-darwin flake that manages macOS system configuration, Homebrew apps, and user environment via Home Manager. Supports multiple machines from a single repo.

## Structure

```
flake.nix                   # Entry point - mkDarwin helper, per-host configs
hosts-config.nix.template   # Template for per-host variables (copy to hosts-config.nix)
hosts/
  common/
    default.nix             # Shared system settings (macOS defaults, Touch ID, etc.)
    homebrew.nix            # Shared Homebrew apps installed on all machines
  personal-mac/
    default.nix             # Imports common, plus host-specific overrides
    homebrew.nix            # Personal-only apps
  work-mac/
    default.nix             # Imports common, plus host-specific overrides
    homebrew.nix            # Work-only apps
home/
  default.nix               # Home Manager entry point, dotfile symlinks
  programs.nix              # Imports all program modules
  programs/
    shell.nix               # shell configuration
    git.nix                 # Git, delta, lazygit, gh
    tmux.nix                # Tmux config and plugins
    cli-tools.nix           # linux cli tooling and helpers
    devops.nix              # kubectl, helm, tenv, tflint, trivy, argocd
    kubernetes.nix          # AKS kubeconfig management (kube-init)
    editors/
      vscode.nix            # VS Code extensions and settings
      neovim.nix            # Neovim with LazyVim
dotfiles/
  ghostty/config            # Ghostty terminal config
  aerospace/.aerospace.toml # AeroSpace window manager config
  nvim/                     # Neovim/LazyVim config
```

## Prerequisites

- macOS on Apple Silicon
- [Determinate Nix installer](https://github.com/DeterminateSystems/nix-installer)

## First-time setup

Copy the template and fill in your values:

```sh
cp hosts-config.nix.template hosts-config.nix
```

Edit `hosts-config.nix` with your hostname, username, git email, and cluster details. This file is gitignored and will never be committed.

## Applying changes

```sh
rebuild
```

This is an alias defined in the config. On first run or if the alias isn't loaded yet, use the full command:

```sh
sudo darwin-rebuild switch --flake ~/dev/workstation-setup#personal-mac
```

Replace `personal-mac` with your config name (the key in `hosts-config.nix`).

## Verifying before applying

Check that the flake evaluates without errors:

```sh
nix flake check
```

Dry-build the config (downloads/builds everything but doesn't activate):

```sh
darwin-rebuild build --flake ~/dev/workstation-setup#personal-mac
```

Check a specific config value:

```sh
nix eval .#darwinConfigurations.personal-mac.config.networking.hostName --raw
```

## Debugging

If `rebuild` fails, add `--show-trace` for full error traces:

```sh
sudo darwin-rebuild switch --flake ~/dev/workstation-setup#personal-mac --show-trace
```

Common issues:

- **"Path not tracked by Git"** -- new files must be `git add`ed before Nix can see them. Nix flakes only see files tracked by git.
- **"attribute not found"** -- usually a typo in a module argument or a missing `specialArgs` value. Check that the function signature in the failing `.nix` file matches what's passed in `flake.nix`.
- **Homebrew zap removing apps** -- `onActivation.cleanup = "zap"` removes anything not declared. If an app disappears after rebuild, add it to the appropriate `homebrew.nix`.

## Adding a new machine

1. Get the machine's hostname:

```sh
scutil --get LocalHostName
```

2. Create a host directory:

```sh
mkdir hosts/<name>
```

3. Add `default.nix` that imports common:

```nix
# hosts/<name>/default.nix
{ ... }:

{
  imports = [
    ../common
    ./homebrew.nix
  ];
}
```

4. Add `homebrew.nix` for host-specific apps (can be empty):

```nix
# hosts/<name>/homebrew.nix
{ ... }:

{
  homebrew = {
    casks = [
      # host-specific casks here
    ];
    brews = [
      # host-specific brews here
    ];
  };
}
```

5. Add the new host to `hosts-config.nix`:

```nix
# hosts-config.nix
{
  # ... existing hosts ...

  new-machine = {
    hostname = "<actual-hostname>";
    hostDir = ./hosts/<name>;
    username = "<macos-username>";
    gitName = "Your Name";
    gitEmail = "you@example.com";
  };
}
```

Add the configuration to `flake.nix`:

```nix
darwinConfigurations."new-machine" = mkDarwin "new-machine" hosts.new-machine;
```

6. Also add the new host entry to `hosts-config.nix.template` with placeholder values, so other users get the template. Then stage and test:

```sh
git add hosts/<name> hosts-config.nix.template
nix flake check
```

## Adding apps to a specific machine

Add casks or brews to that host's `homebrew.nix`. For example, to add Slack to the work machine only:

```nix
# hosts/work-mac/homebrew.nix
{ ... }:

{
  homebrew = {
    casks = [
      "slack"
    ];
  };
}
```

The nix module system merges lists, so this combines with whatever is in `hosts/common/homebrew.nix`.

To add an app to all machines, add it to `hosts/common/homebrew.nix` instead.

## Adding CLI tools or Nix packages

Edit the relevant file under `home/programs/`. Nix packages go in `cli-tools.nix` or `devops.nix`. Programs with Home Manager modules (like git, tmux, bat) get their own config blocks.

## Updating dependencies

```sh
nix flake update
```

This updates all flake inputs (nixpkgs, home-manager, nix-darwin, etc.) to their latest versions. Review changes with `git diff flake.lock` before rebuilding.
