{ pkgs, lib, ... }: {
  imports = [ ../base/default.nix ];
  environment.etc.machine-id.text = "53ce9ee8540445a49241d28f5ca77d52";

  hardware.opengl.enable = true;
  # Intel kmod firmware is unfree, allow all unfree firmware
  nixpkgs.config.allowUnfreePredicate = pkg:
    ((pkg.meta or {}).sourceProvenance or []) == [ lib.sourceTypes.binaryFirmware ];

  programs.sway.enable = true;
  services.dbus.enable = true;

  networking.hostId = "12345678";
  fileSystems."/" = {
    device = "zpool/empty";
    fsType = "zfs";
  };

  fileSystems."/nix/store" = {
    device = "zpool/nix/store";
    fsType = "zfs";
  };

  fileSystems."/nix/var" = {
    device = "zpool/nix/var";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "zpool/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/msdosfs/SHARED_BOOT";
    fsType = "msdosfs";
  };

  boot.linux.enable = true;
}
