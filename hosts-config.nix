# Host-specific values. This file is tracked by git with placeholders.
# After cloning, edit with real values then run:
#   git update-index --skip-worktree hosts-config.nix
# To undo (before changing the template):
#   git update-index --no-skip-worktree hosts-config.nix
{
  personal-mac = {
    hostname = "CHANGEME";
    hostDir = ./hosts/personal-mac;
    username = "CHANGEME";
    gitName = "CHANGEME";
    gitEmail = "CHANGEME";
  };

  work-mac = {
    hostname = "CHANGEME";
    hostDir = ./hosts/work-mac;
    username = "CHANGEME";
    gitName = "CHANGEME";
    gitEmail = "CHANGEME";
  };
}
