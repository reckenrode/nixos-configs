# SPDX-License-Identifier: MIT

{ config, lib, ... }:

let
  inherit (lib) concatMapStringsSep;

  cfg = config.services.openssh;
in
{
  options.services.openssh.hardening = lib.mkEnableOption "Enable sshd hardening settings";

  config = lib.mkIf cfg.hardening {
    networking.nftables.ruleset = ''
      table inet filter {
        chain input {
          ${concatMapStringsSep "\n" (port: "tcp dport ${toString port} accept") cfg.ports}
        }
      }
    '';

    services.openssh = {
      extraConfig = "HostKeyAlgorithms -ssh-rsa";
      kexAlgorithms = [
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group14-sha256"
        "diffie-hellman-group16-sha512"
        "diffie-hellman-group18-sha512"
        "diffie-hellman-group-exchange-sha256"
      ];
      macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
      ];
      passwordAuthentication = false;
    };
  };
}
