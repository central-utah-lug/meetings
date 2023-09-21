{ pkgs ? import <nixpkgs> {} }:
let
  marp = pkgs.writeShellScriptBin "marp" ''
    ${pkgs.nodejs}/bin/npx @marp-team/marp-cli@latest $@
  '';
in pkgs.mkShell {
  buildInputs = [ marp ];
  shellHook = ''
    export PATH=$PATH:${pkgs.nodejs}/bin
    export PATH=$PATH:${marp}/bin
  '';
}
