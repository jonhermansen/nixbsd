{ config, lib, ... }: {
  imports = [ ../base/default.nix ];

  nixpkgs.overlays = [
    (import ../../overlays/freebsd-main.nix)
    (final': prev': {
      freebsd = prev'.freebsd.overrideScope (final: prev: {
        sysctl = prev.sysctl.overrideAttrs {
          MK_JAIL = "no";
        };
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
      });
    })
  ];

  #virtualisation.vmVariant.virtualisation.diskImage = lib.mkOverride 10 null;
  #virtualisation.vmVariant.virtualisation.netMountNixStore = true;
  #virtualisation.vmVariant.virtualisation.netMountBoot = true;
  #readOnlyNixStore.writableLayer = "/nix/.rw-store";
}
