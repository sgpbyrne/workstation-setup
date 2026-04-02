{ lib, username, ... }:

let
  profilesDir = "/Users/${username}/Library/Application Support/Firefox";
in
{
  # Scaffold Firefox profiles if Firefox hasn't been launched yet
  # Policies and extensions are managed at system level (hosts/common/default.nix)
  # because they need to run after Homebrew installs Firefox
  home.activation.firefoxSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f "${profilesDir}/profiles.ini" ]; then
      mkdir -p "${profilesDir}/Profiles/work"
      mkdir -p "${profilesDir}/Profiles/personal"
      cat > "${profilesDir}/profiles.ini" << 'PROFILES_EOF'
[Profile0]
Name=Work
IsRelative=1
Path=Profiles/work
Default=1

[Profile1]
Name=Personal
IsRelative=1
Path=Profiles/personal

[General]
StartWithLastProfile=1
Version=2
PROFILES_EOF
    fi
  '';
}
