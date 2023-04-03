# SPDX-License-Identifier: MIT

{ pkgs, lib, inputs, ... }:

{
  environment.darwinConfig = inputs.self + /hosts/natalia/configuration.nix;

  environment.defaultPackages = lib.attrValues { inherit (pkgs) neovim perl rsync; };
  environment.variables.EDITOR = "${lib.getBin pkgs.neovim}/bin/nvim";

  environment.systemPackages = lib.attrValues {
    inherit (pkgs) iterm2;
    inherit (inputs.nix-packages.packages.${pkgs.system}) daisydisk netnewswire secretive;
    inherit (inputs.nix-packages.packages.${pkgs.system}.pkgsx86_64Darwin) steam-mac;
    inherit (inputs.nix-unstable-packages.packages.${pkgs.system}.pkgsx86_64Darwin) ffxiv;
    inherit (inputs.verify-archive.packages.${pkgs.system}) verify-archive;
  };

  hardware.printers = [
    {
      name = "HP_Color_LaserJet_Pro_M454dw";
      icon = inputs.self + /hosts/natalia/M453dw.icns;
      suppliesUrl = "https://jihli.infra.largeandhighquality.com/#hId-pgConsumables";
    }
  ];

  home-manager.users = { inherit (inputs.self.homeModules) reckenrode; };
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "vscode" ];

  networking.hostName = "natalia";

  nix = {
    configureBuildUsers = true;

    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };

    optimise.automatic = true;

    settings = {
      extra-platforms = [ "x86_64-darwin" ];
      sandbox = "relaxed";
    };

    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
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
