{ pkgs, stand-efi, initmd }:
let
  loaderScript = pkgs.writeText "nixbsd-loader.lua" (builtins.readFile ./nixbsd-loader.lua);
in
pkgs.replaceVarsWith {
  src = ./stand-conf-builder.sh;
  isExecutable = true;
  replacements = {
    path = [ pkgs.coreutils pkgs.gnused pkgs.gnugrep pkgs.jq ];
    stand = stand-efi;
    loader_script = loaderScript;
    inherit (pkgs) bash;
    initmd = if initmd == null then "" else initmd;
  };
}
