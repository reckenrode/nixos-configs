# SPDX-License-Identifier: MIT

{ lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./file-server.nix
    ./samba.nix
    ./systemd-networkd.nix
  ];

  boot.initrd.systemd.enable = true;

  # Use the LTS kernel from nixpkgs-unstable to ensure compatibility with the ZFS modules.
  # FIXME: Use the stable LTS kernel once 23.05 is released.
  boot.kernelPackages = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.linuxPackages;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };

  home-manager.users.reckenrode = inputs.self.homeModules.server-admin;

  networking.hostName = "meteion";
  networking.hostId = "41b9e6d1";

  networking.nftables.enable = true;

  networking.wireless.iwd.enable = true;

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    optimise.automatic = true;

    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
  };

  programs.fish.enable = true;

  security.sudo = {
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };

  services.openssh = {
    enable = true;
    hardening = true;
    ports = [ 562 ];
  };

  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="sd[a-z]*[0-9]*|mmcblk[0-9]*p[0-9]*|nvme[0-9]*n[0-9]*p[0-9]*", ENV{ID_FS_TYPE}=="zfs_member", ATTR{../queue/scheduler}="none"
  '';
  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.pools = [ "meteia" "ultima-thule" ];

  sops.defaultSopsFile = ./secrets.yaml;

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "03:00";
    flake = "github:reckenrode/nixos-configs";
  };

  system.stateVersion = "22.11";

  time.timeZone = "America/New_York";

  users.mutableUsers = false;

  users.users.reckenrode = {
    description = "Randy Eckenrode";
    shell = pkgs.fish;

    isNormalUser = true;
    extraGroups = [ "wheel" "samba-guest" ];

    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNEN6b+msDHGPwNNPZS2KGW77Alc9zU8Tislj/PxV7rO8Vkz2FhS9rjjd8ZQlSnn+YgqFuJamNEyR78WgclgKsM="
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
