{ config, lib, ... }: {
  imports = [ ../graphical/default.nix ];

  nixpkgs.overlays = [
    (import ../../overlays/freebsd-main.nix)
    (final': prev': {
      freebsd = prev'.freebsd.overrideScope (final: prev: {
        sysctl = prev.sysctl.overrideAttrs (oldAttrs: {
          buildInputs = (oldAttrs.buildInputs or []) ++ [
            prev.libjail
          ];
        });
        syslogd = prev.syslogd.overrideAttrs (oldAttrs: {
          buildInputs = (oldAttrs.buildInputs or []) ++ [
            prev.libcasper
            prev.libcapsicum
            prev.libnv
          ];
        });
        stand-efi = prev.stand-efi.overrideAttrs (oldAttrs: {
          # Add elfcopy to nativeBuildInputs so it's in PATH during build
          #nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ final'.elfcopy ];
          # JAH TODO: Why isn't the NixBSD patch being applied here?
          preBuild = (oldAttrs.preBuild or "") + ''
            #exit 1
            sed -i 's/date -ur /date -ud @/' ../common/newvers.sh
          '';
        });
        drm-kmod-firmware = prev.drm-kmod-firmware.overrideAttrs (oldAttrs: {
          hardeningDisable = (oldAttrs.hardeningDisable or []) ++ [ "fortify" ];

          XARGS = "${final.buildFreebsd.xargs-j}/bin/xargs-j";
          XARGS_J = "";
        });
      });
      epoll-shim = prev'.epoll-shim.overrideAttrs (oldAttrs: {
        hardeningDisable = (oldAttrs.hardeningDisable or []) ++ [ "fortify" ];
      });
      mesa = prev'.mesa.override {
galliumDrivers = [
    "d3d12" # WSL emulated GPU (aka Dozen)
    #"iris" # new Intel (Broadwell+)
    "llvmpipe" # software renderer
    "nouveau" # Nvidia
    "r300" # very old AMD
    "r600" # less old AMD
    "radeonsi" # new AMD (GCN+)
    "softpipe" # older software renderer
    "svga" # VMWare virtualized GPU
    "virgl" # QEMU virtualized GPU (aka VirGL)
    "zink" # generic OpenGL over Vulkan, experimental
];
vulkanDrivers = [
    "amd" # AMD (aka RADV)
    #"intel" # new Intel (aka ANV)
    "microsoft-experimental" # WSL virtualized GPU (aka DZN/Dozen)
    "swrast" # software renderer (aka Lavapipe)
#] ++ lib.optionals stdenv.hostPlatform.isx86 [
#  #"intel_hasvk" # Intel Haswell/Broadwell, "legacy" Vulkan driver (https://www.phoronix.com/news/Intel-HasVK-Drop-Dead-Code)
];
#eglPlatforms = [ "x11" "wayland" ]
#vulkanLayers = [
#  "device-select"
#  "overlay"
#  "intel-nullhw"
#];
      };
      sway = prev'.sway.override {
        #enableXwayland = false;
      };
      swaybg = prev'.swaybg.overrideAttrs {
        hardeningDisable = [ "stackprotector" "fortify" ];
      };
      swaylock = prev'.swaylock.overrideAttrs {
        hardeningDisable = [ "stackprotector" "fortify" ];
      };
    })
  ];

  #virtualisation.vmVariant.virtualisation.diskImage = lib.mkOverride 10 null;
  #virtualisation.vmVariant.virtualisation.netMountNixStore = true;
  #virtualisation.vmVariant.virtualisation.netMountBoot = true;
  #readOnlyNixStore.writableLayer = "/nix/.rw-store";
}
