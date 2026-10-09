{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

pkgs.callPackage ./pkgs/ncalayer/package.nix { }
