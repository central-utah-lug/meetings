{
  description = "central-utah-lug meetings";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      marp = pkgs.writeShellScriptBin "marp" ''
        ${pkgs.nodejs}/bin/npx @marp-team/marp-cli@latest $@
      '';
    in {
      devShell = pkgs.mkShell {
        name = "meetings-dev-shell";
        buildInputs = with pkgs; [
          nodejs
          marp
        ];
      };

      formatter = pkgs.alejandra;
    });
}
