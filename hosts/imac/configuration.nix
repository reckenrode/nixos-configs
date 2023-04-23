# SPDX-License-Identifier: MIT

{ pkgs, lib, inputs, ... }:

{
  environment.darwinConfig = inputs.self + /hosts/natalia/configuration.nix;

  environment.systemPackages = lib.attrValues {
    inherit (pkgs) iterm2
      bzip2 coreutils curl diffutils findutils gnutar gzip less openssh time unzip zip zstd;
    inherit (inputs.verify-archive.packages.${pkgs.system}) verify-archive;
  };

  hardware.printers = [
    {
      name = "HP_Color_LaserJet_Pro_M454dw";
      icon = inputs.self + /hosts/natalia/M453dw.icns;
      suppliesUrl = "https://jihli.infra.largeandhighquality.com/#hId-pgConsumables";
    }
  ];

  home-manager.users =  {
    reckenrode = inputs.self.homeModules.server-admin;

    weiweilin = { pkgs, ... }: {
      home.packages = lib.attrValues { inherit (pkgs) python3Full poetry; };

      programs.git = {
        enable = true;
        userEmail = "stormer.boxes-06@icloud.com";
        userName = "Weiwei Lin";
        extraConfig = {
          init = { defaultBranch = "main"; };
          credential.helper = "${pkgs.git}/bin/git-credential-osxkeychain";
        };
      };

      programs.vscode.enable = true;
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "vscode" ];

  networking.hostName = "iMac";

  nix = {
    configureBuildUsers = true;

    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };

    optimise.automatic = true;

    settings.sandbox = "relaxed";

    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
  };

  programs = {
    bash.enable = false;
    fish.enable = true;
    zsh.enable = true;
  };

  security.pam.enableSudoTouchIdAuth = true;

  services.nix-daemon.enable = true;

  system.stateVersion = 4;

  users.users.reckenrode = {
    description = "Randy Eckenrode";
    shell = pkgs.fish;
    home = "/Users/reckenrode";
  };

  users.users.weiweilin = {
    description = "Weiwei Lin";
    shell = pkgs.zsh;
    home = "/Users/weiweilin";
  };
}
