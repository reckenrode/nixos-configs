# SPDX-License-Identifier: MIT

{ lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.initrd.systemd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages;

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };

  home-manager.users.reckenrode = inputs.self.hmModules.server-admin;

  networking.hostName = "vamp";

  networking.nftables.enable = true;

  nix = {
    settings.extra-platforms = lib.mkForce [ "i686-linux" "x86_64-linux" ];

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

#  sops.defaultSopsFile = ./secrets.yaml;

#  system.autoUpgrade = {
#    enable = true;
#    allowReboot = true;
#    dates = "03:00";
#    flake = "github:reckenrode/nixos-configs/refactor";
#  };

  system.stateVersion = "23.05";

  systemd.network.networks.lan = {
    enable = true;
    matchConfig.Name = "enp0s1";
    networkConfig = {
      DHCP = "ipv4";
      IPv6PrivacyExtensions = true;
      IPv6AcceptRA = true;
    };
  };

  time.timeZone = "America/New_York";

  users.mutableUsers = false;

  users.users.reckenrode = {
    description = "Randy Eckenrode";
    shell = pkgs.fish;

    isNormalUser = true;
    extraGroups = [ "wheel" ];

    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNEN6b+msDHGPwNNPZS2KGW77Alc9zU8Tislj/PxV7rO8Vkz2FhS9rjjd8ZQlSnn+YgqFuJamNEyR78WgclgKsM="
    ];
  };

  boot.binfmt.emulatedSystems = [ "i386-linux" "i686-linux" ];
  virtualisation.rosetta.enable = true;

  zramSwap = {
    enable = true;
    memoryMax = 8 * 1024 * 1024 * 1024;
    memoryPercent = 100;
  };
}

