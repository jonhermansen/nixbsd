{ config, lib, ... }: {
  nixpkgs.hostPlatform = "x86_64-freebsd";

  users.users.root.initialPassword = "toor";

  # Don't make me wait for an address...
  networking.dhcpcd.wait = "background";

  users.users.bestie = {
    isNormalUser = true;
    description = "your bestie";
    extraGroups = [ "wheel" ];
    inherit (config.users.users.root) initialPassword;
  };

  services.sshd.enable = true;
  boot.loader.stand-freebsd.enable = true;

  fileSystems."/" = {
    device = "zpool/freebsd15";
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

  virtualisation.vmVariant.virtualisation.diskImage = "./${config.system.name}.qcow2";
  virtualisation.vmVariant.virtualisation.netMountBoot = false;

}
