{ ... }:

{
  imports = [
    ./programs/shell.nix
    ./programs/tmux.nix
    ./programs/git.nix
    ./programs/cli-tools.nix
    ./programs/devops.nix
    ./programs/kubernetes.nix
    ./programs/editors/vscode.nix
    ./programs/editors/neovim.nix
  ];
}
