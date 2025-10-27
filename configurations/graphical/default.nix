{ pkgs, lib, ... }: {
  imports = [ ../base/default.nix ];
  environment.etc.machine-id.text = "53ce9ee8540445a49241d28f5ca77d52";

  hardware.opengl.enable = true;
  # Intel kmod firmware is unfree, allow all unfree firmware
  nixpkgs.config.allowUnfreePredicate = pkg:
    ((pkg.meta or {}).sourceProvenance or []) == [ lib.sourceTypes.binaryFirmware ];

  programs.sway.enable = true;
  #programs.sway.extraPackages = [];

  services.dbus.enable = true;
#  services.xserver = {
#    enable = true;
#    displayManager.lightdm.enable = true;
#    displayManager.defaultSession = "xfce";
#    desktopManager.xfce = {
#      enable = true;
#    };
#    exportConfiguration = true;
#    libinput.enable = true; # for touchpad support on many laptops
#  };

  environment.xfce.excludePackages = with pkgs; [
    xfce.parole
    xfce.ristretto
    xfce.xfce4-screenshooter
    xfce.xfce4-notifyd
  ];
  #services.pulseaudio.enable = false;
  #services.pipewire.pulse.enable = false;
  #security.polkit.enable = lib.mkForce false;
}
