{ ... }:

{
  boot.kernelParams = [ "console=ttyS0,19200n8" ];
  boot.loader.grub.extraConfig = ''
    serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
    terminal_input serial;
    terminal_output serial
  '';

  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.loader.timeout = 10;
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };
}
