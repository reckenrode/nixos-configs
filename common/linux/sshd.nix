{ ... }:

{
  networking.nftables.ruleset = ''
    table inet filter {
      chain input {
        tcp dport 562 accept
      }
    } 
  '';

  services.openssh = {
    enable = true;
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
    ports = [ 562 ];
  };
}
