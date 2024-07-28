# SPDX-License-Identifier: MIT

{
  lib,
  config,
  pkgs,
  ...
}:

let
  defaultPackages = lib.attrValues { inherit (pkgs) nano perl rsync; };

  cfg = config.programs;
in
{
  options.programs.nixosPackagesCompat.enable = lib.mkOption {
    description = "Match the required packages in NixOS as best as possible on Darwin platforms";
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf cfg.nixosPackagesCompat.enable {
    environment.systemPackages = lib.attrValues {
      inherit (pkgs)
        bzip2
        coreutils-full
        cpio
        curl
        diffutils
        findutils
        gawk
        getent
        getconf
        gnugrep
        gnupatch
        gnused
        gnutar
        gzip
        xz
        less
        ncurses
        netcat
        openssh
        procps
        time
        util-linux
        which
        zstd
        unzip
        ;
    };
  };
}
