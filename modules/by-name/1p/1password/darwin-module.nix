# SPDX-License-Identifier: MIT

# Based on:
# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/_1password.nix
# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/_1password-gui.nix

{ config, lib, pkgs, ... }:

let
  inherit (lib) types;

  cfg-cli = config.programs._1password;
  cfg-gui = config.programs._1password-gui;
in
{
  options.programs = {
    _1password = {
      enable = lib.mkEnableOption "Whether to enable the 1Password CLI tool.";
      copyToUsrLocal = lib.mkOption {
        description = "Copy `op` to `/usr/local/bin`. This is required to share authentication with the desktop app.";
        type = types.bool;
        default = true;
      };
      package = lib.mkOption {
        description = "The 1Password CLI package to use.";
        type = types.package;
        default = pkgs._1password;
      };
    };
    _1password-gui = {
      enable = lib.mkEnableOption "Whether to enable the 1Password GUI application.";
      copyToApplications = lib.mkOption {
        description = "Copy `1Password.app` to `/Applications`. This is required to share authentication with extensions and the CLI tool.";
        type = types.bool;
        default = true;
      };
      package = lib.mkOption {
        description = "The 1Password CLI package to use.";
        type = types.package;
        default = pkgs._1password-gui;
      };
    };
  };

  config =
    let
      _1password-cli-cfg = lib.mkIf cfg-cli.enable {
        environment.systemPackages = lib.optional (!cfg-cli.copyToUsrLocal) cfg-cli.package;

        system.activationScripts.postActivation.text =
          lib.optionalString cfg-cli.copyToUsrLocal ''
            install -o root -g wheel -m0555 -D \
              ${lib.getBin cfg-cli.package}/bin/op /usr/local/bin/op
          '';
      };
      _1password-gui-cfg = lib.mkIf cfg-gui.enable {
        environment.systemPackages = lib.optional (!cfg-gui.copyToApplications) cfg-gui.package;

        system.activationScripts.postActivation.text =
          lib.optionalString cfg-gui.copyToApplications ''
            appsDir="/Applications/Nix Apps"
            if [ -d "$appsDir" ]; then
              rm -rf "$appsDir/1Password.app"
            fi

            app="/Applications/1Password.app"
            if [ -L "$app" ] || [ -f "$app"  ]; then
              rm "$app"
            fi
            install -o root -g wheel -m0555 -d "$app"

            rsyncFlags=(
              --archive
              --checksum
              --chmod=-w
              --copy-unsafe-links
              --delete
              --no-group
              --no-owner
            )
            ${lib.getBin pkgs.rsync}/bin/rsync "''${rsyncFlags[@]}" \
              ${cfg-gui.package}/Applications/1Password.app/ /Applications/1Password.app
          '';
      };
    in
    lib.mkMerge [ _1password-cli-cfg _1password-gui-cfg ];
}
