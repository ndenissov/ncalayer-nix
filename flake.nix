{
  description = "NCALayer digital signature client for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: {
        default = pkgs.callPackage ./pkgs/ncalayer/package.nix { };
        ncalayer = pkgs.callPackage ./pkgs/ncalayer/package.nix { };
      });

      overlays.default = final: prev: {
        ncalayer = final.callPackage ./pkgs/ncalayer/package.nix { };
      };
    };
}
