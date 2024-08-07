# SPDX-License-Identifier: MIT

{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib)
    concatStringsSep
    optionalAttrs
    readFile
    types
    ;
  inherit (lib.trivial) pipe;
  inherit (pkgs) stdenv substituteAll;
in
{
  options.services.dhcpV6Client = {
    openFirewall = lib.mkEnableOption "Open the firewall to allow DHCPv6 on the specified interfaces";
    interfaces = lib.mkOption {
      default = [ ];
      defaultText = "[]";
      example = ''[ "enp1s0" ]'';
      description = "The interfaces for which to set up firewall rules to allow DHCPv6";
      type = types.listOf types.str;
    };
  };

  config =
    let
      inherit (config.services.dhcpV6Client) interfaces;

      generateFirewallRules =
        interface:
        readFile (substituteAll {
          inherit interface;
          src = ./dhcpV6Client.nft;
        });
    in
    lib.mkIf config.services.dhcpV6Client.openFirewall {
      networking.nftables.ruleset = pipe interfaces [
        (map generateFirewallRules)
        (concatStringsSep "\n")
      ];
    };
}
