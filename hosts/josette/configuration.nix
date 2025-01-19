# SPDX-License-Identifier: MIT

{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

let
  nonfree-unstable = import inputs.nixpkgs-unstable {
    localSystem = pkgs.system;
    config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "1password"
        "1password-cli"
      ];
  };
in
{
  environment.darwinConfig = inputs.self + /hosts/josette/configuration.nix;

  environment.defaultPackages = lib.attrValues { inherit (pkgs) neovim perl rsync; };
  environment.variables.EDITOR = "${lib.getExe pkgs.neovim}";
  environment.variables.PAGER = "${lib.getExe pkgs.less} -RF";

  environment.systemPackages = lib.attrValues {
    inherit (pkgs) iterm2;
    inherit (inputs.nix-packages.packages.${pkgs.system}) netnewswire secretive;
    inherit (inputs.nix-packages.packages.x86_64-darwin) steam-mac;
    inherit (inputs.nix-unstable-packages.packages.x86_64-darwin) ffxiv;
    inherit (inputs.verify-archive.packages.${pkgs.system}) verify-archive;
  };

  hardware.printers = [
    {
      name = "HP_Color_LaserJet_Pro_M454dw";
      icon = inputs.self + /hosts/josette/M453dw.icns;
      suppliesUrl = "https://jihli.infra.largeandhighquality.com/#hId-pgConsumables";
    }
  ];

  home-manager.users = {
    inherit (inputs.self.hmModules) reckenrode;
  };
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "1password"
      "1password-cli"
      "vscode"
    ];

  networking.hostName = "josette";

  environment.etc."ssh/ssh_config.d/101-linux-builder.conf".text = ''
    Match User builder Host meteion.infra.largeandhighquality.com
      IdentityAgent ${config.users.users.reckenrode.home}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
      Port 562
  '';

  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "meteion.infra.largeandhighquality.com";
        protocol = "ssh-ng";
        sshUser = "builder";
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUZqSTEwaVM0VklNMVpuOUxnV0wydG1YY0lhUTROTGtjS1JUTkNQSjQ0U2ggcm9vdEBtZXRlaW9uCg==";
        supportedFeatures = [
          "kvm"
          "benchmark"
          "big-parallel"
        ];
        system = "x86_64-linux";
      }
      {
        hostName = "meteion.infra.largeandhighquality.com";
        protocol = "ssh-ng";
        sshUser = "builder";
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUZqSTEwaVM0VklNMVpuOUxnV0wydG1YY0lhUTROTGtjS1JUTkNQSjQ0U2ggcm9vdEBtZXRlaW9uCg==";
        supportedFeatures = [
          "kvm"
          "benchmark"
          "big-parallel"
        ];
        system = "i686-linux";
      }
    ];
  };

  nix = {
    configureBuildUsers = true;

    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };

    settings = {
      auto-optimise-store = true;
      extra-platforms = [ "x86_64-darwin" ];
      extra-trusted-users = [ "reckenrode" ];
      max-jobs = 4;
      sandbox = false;
      builders-use-substitutes = true;
      use-xdg-base-directories = true;
    };

    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
  };

  programs._1password = {
    enable = true;
    package = nonfree-unstable._1password-cli;
  };

  programs._1password-gui = {
    enable = true;
    package = nonfree-unstable._1password-gui;
  };

  programs = {
    bash.enable = false;
    fish.enable = true;
  };

  security.pam.enableSudoTouchIdAuth = true;

  services.nix-daemon.enable = true;

  system.stateVersion = 4;

  users.users.reckenrode = {
    description = "Randy Eckenrode";
    shell = pkgs.fish;
    home = "/Users/reckenrode";
  };
}
