{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    ripgrep
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -x EDITOR "${pkgs.neovim}/bin/nvim";
    '';
    functions = {
      darwin-rebuild = ''
        command darwin-rebuild $argv
        if string match -q switch -- $argv
          ${pkgs.nvd}/bin/nvd diff /run/current-system result && rm result
        end
      '';
    };
  };

  home.stateVersion = "21.05";
}
