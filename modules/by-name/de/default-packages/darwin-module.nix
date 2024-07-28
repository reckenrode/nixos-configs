# SPDX-License-Identifier: MIT
# Based on github:NixOS/nixpkgs/nixos/modules/config/system-path.nix

{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    concatMapStringsSep
    literalMD
    setPrio
    types
    ;

  defaultPackageNames = [
    "nano"
    "perl"
    "rsync"
    #    "strace"
  ];

  defaultPackages = map (
    n:
    let
      pkg = pkgs.${n};
    in
    setPrio ((pkg.meta.priority or 5) + 3) pkg
  ) defaultPackageNames;
  defaultPackagesText = "[ ${concatMapStringsSep " " (n: "pkgs.${n}") defaultPackageNames} ]";
in
{
  options.environment.defaultPackages = lib.mkOption {
    type = types.listOf types.package;
    default = defaultPackages;
    defaultText = literalMD ''
      these packages, with their `meta.priority` numerically increased
      (thus lowering their installation priority):

          ${defaultPackagesText}
    '';
    example = [ ];
    description = lib.mdDoc ''
      Set of default packages that aren't strictly necessary
      for a running system, entries can be removed for a more
      minimal NixOS installation.

      Note: If `pkgs.nano` is removed from this list,
      make sure another editor is installed and the
      `EDITOR` environment variable is set to it.
      Environment variables can be set using
      {option}`environment.variables`.

      Like with systemPackages, packages are installed to
      {file}`/run/current-system/sw`. They are
      automatically available to all users, and are
      automatically updated every time you rebuild the system
      configuration.
    '';
  };

  config.environment.systemPackages = config.environment.defaultPackages;
}
