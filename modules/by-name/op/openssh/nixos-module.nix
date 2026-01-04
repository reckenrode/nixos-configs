# SPDX-License-Identifier: MIT

{ lib, config, ... }:

let
  inherit (lib) concatMapStringsSep;

  cfg = config.services.openssh;
in
{
  options.services.openssh.hardening = lib.mkEnableOption "Enable sshd hardening settings";

  config = lib.mkIf cfg.hardening {
    networking.nftables.ruleset = ''
      table inet firewall-cfg {
        chain input {
          ${concatMapStringsSep "\n" (port: "tcp dport ${toString port} accept") cfg.ports}
        }
      }
    '';

    services.openssh = {
      extraConfig = "HostKeyAlgorithms -ssh-rsa";
      settings = {
        KexAlgorithms = [
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
          "diffie-hellman-group14-sha256"
          "diffie-hellman-group16-sha512"
          "diffie-hellman-group18-sha512"
          "diffie-hellman-group-exchange-sha256"
          "mlkem768x25519-sha256"
          "sntrup761x25519-sha512"
        ];
        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
        ];
        PasswordAuthentication = false;
      };
    };
  };
}
