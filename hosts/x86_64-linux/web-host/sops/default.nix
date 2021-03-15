{ config, ... }:

{
  sops.defaultSopsFile = ./secrets.yaml;

  sops.secrets.github_token = {
    path = "/root/.ssh/id_ed25519";
    mode = "0400";
  };
}