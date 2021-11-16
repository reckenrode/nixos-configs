{ config, lib, pkgs, ... }:

let
  inherit (builtins) readFile map;
  inherit (lib) optionalAttrs types;
  inherit (lib.trivial) pipe;
  inherit (pkgs) stdenv substituteAll;
in
optionalAttrs stdenv.isLinux {
  options.roles.dhcp6Client = {
    enable = lib.mkEnableOption "Open the firewall to allow DHCPv6 on the specified interfaces";
    interfaces = lib.mkOption {
      default = [];
      defaultText = "[]";
      example = ''[ "enp1s0" ]'';
      description = "The interfaces for which to set up firewall rules to allow DHCPv6";
      type = types.listOf types.string;
    };
  };
  config =
    let
      inherit (config.roles.dhcp6Client) interfaces;

      generateFirewallRules = interface: readFile (pkgs.substituteAll {
        inherit interface;
        src = ./dhcp6Client.nft;
      });
    in
    lib.mkIf config.roles.dhcp6Client.enable {
      networking.nftables.ruleset = pipe interfaces [
        (map generateFirewallRules)
        (builtins.concatStringsSep "\n")
      ];
    };
}
