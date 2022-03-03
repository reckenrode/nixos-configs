{ config
, lib
, pkgs
, ...
}:

{
  system.activationScripts.applications.text = lib.mkForce ''
    echo "Setting up /Applications/Nix Apps" >&2
    appsSrc="${config.system.build.applications}/Applications/"
    baseDir="/Applications/Nix Apps"
    rsyncArgs="--archive --checksum --chmod=-w --copy-unsafe-links --delete"
    mkdir -p "$baseDir"
    ${pkgs.rsync}/bin/rsync $rsyncArgs "$appsSrc" "$baseDir"
  '';
}
