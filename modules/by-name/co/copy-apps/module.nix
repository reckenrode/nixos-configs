# SPDX-License-Identifier: MIT

{
  config,
  lib,
  pkgs,
  ...
}:

let
  appsSrc =
    if config ? home then
      "$newGenPath/home-path/Applications"
    else
      config.system.build.applications + /Applications;

  baseDir =
    if config ? home then
      "${config.home.homeDirectory}/Applications/Home Manager Apps"
    else
      "/Applications/Nix Apps";

  copyScript =
    lib.optionalString (config ? system) ''
      echo 'Setting up /Applications/Nix Apps...' >&2
    ''
    + ''
      appsSrc="${appsSrc}"
      if [ -d "$appsSrc" ]; then
        workDir=$(mktemp -d)
        # shellcheck disable=SC2064
        trap "rm -rf -- '$workDir'" EXIT

        while IFS= read -r -d "" app; do
          mkdir -p "$workDir/$app"
          ln -s "$(realpath "$appsSrc/$app/Contents")" "$workDir/$app/Contents"
        done < <(${lib.getExe pkgs.findutils} "$appsSrc" -name '*.app' -and -not -path '*.app/*.app' -printf '%P\0')

        baseDir="${baseDir}"
        rsyncFlags=(
          "--archive"
          "--checksum"
          "--chmod=-w,uog+rx"
          "--delete"
          "--no-group"
          "--no-owner"
        )
        $DRY_RUN_CMD mkdir -p "$baseDir"
        $DRY_RUN_CMD ${lib.getBin pkgs.rsync}/bin/rsync \
          ''${VERBOSE_ARG:+-v} "''${rsyncFlags[@]}" "$workDir/" "$baseDir"
      fi
    '';

  isHomeManager = lib.hasAttr "hm" lib;
in
{
  disabledModules = [ "targets/darwin/linkapps.nix" ];

  config = lib.mkIf pkgs.stdenv.isDarwin (
    lib.optionalAttrs isHomeManager {
      home.activation.copyApplications = lib.hm.dag.entryAfter [ "writeBoundary" ] copyScript;
    }
    // lib.optionalAttrs (!isHomeManager) {
      system.activationScripts.applications.text = lib.mkForce copyScript;
    }
  );
}
