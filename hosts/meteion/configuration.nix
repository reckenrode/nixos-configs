# SPDX-License-Identifier: MIT

{ pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./file-server.nix
    ./jellyfin-server.nix
    ./samba.nix
    ./systemd-networkd.nix
  ];

  boot.initrd.systemd.enable = true;

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };

  home-manager.users.reckenrode = inputs.self.hmModules.server-admin;

  networking.hostName = "meteion";
  networking.hostId = "41b9e6d1";

  networking.nftables.enable = true;

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    settings = {
      max-jobs = 3;
      trusted-users = [ "builder" ];
    };

    optimise.automatic = true;

    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
  };

  programs.fish.enable = true;

  services.mysql = {
    enable = true;
    ensureDatabases = [ "practice" ];
    package = pkgs.mariadb;
    settings.mysqld = {
      plugin-load-add = [ "ed25519=auth_ed25519" ];
    };
  };
  networking.nftables.ruleset = ''
    table inet firewall-cfg {
      chain input {
        iifname wlan0 meta l4proto tcp ip6 saddr fda9:51fe:3bbf:c9f::/64 th dport 3306 accept
        iifname wlan0 meta l4proto tcp ip  saddr        192.168.238.0/24 th dport 3306 accept
      }
    }
  '';

  security.sudo = {
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };

  services.openssh = {
    enable = true;
    hardening = true;
    ports = [ 562 ];
  };

  sops.defaultSopsFile = ./secrets.yaml;

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "02:30";
    flake = "github:reckenrode/nixos-configs";
  };

  system.stateVersion = "26.05";

  time.timeZone = "America/New_York";

  users.mutableUsers = false;

  users.users.builder = {
    description = "Remote Build User";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC4tyLMYbXgSoL7ijv0O7/dz6XwAsnHGEdVY1igU5T0s"
    ];
  };

  users.users.reckenrode = {
    description = "Randy Eckenrode";
    shell = pkgs.fish;

    isNormalUser = true;
    extraGroups = [
      "wheel"
      "samba-guest"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGguVTMbggjvHvKes/BKkDT54np8oPgVYm7VnyTe9lH6"
    ];
  };

  users.users.weiweilin = {
    description = "Weiwein Lin";
    shell = pkgs.shadow;

    isNormalUser = true;

    home = "/var/empty";
    createHome = false;
  };

  zramSwap = {
    enable = true;
    memoryMax = 8 * 1024 * 1024 * 1024;
    memoryPercent = 100;
  };
}
