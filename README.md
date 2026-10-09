# NCALayer Nix Flake

The Nix Flake providing **NCALayer** (the digital signature EDS client for Kazakhstan government portals).

> **Note:** You can support adding this package directly to nixpkgs by leaving a 👍 reaction on the PR **https://github.com/NixOS/nixpkgs/pull/540015**

## Quick Run (Without Installation)

Run directly using `nix run`:

```bash
# Start in the background
nix run github:ndenissov/ncalayer-nix -- --run

# Open configuration or module manager
nix run github:ndenissov/ncalayer-nix -- --settings
nix run github:ndenissov/ncalayer-nix -- --bundle-manager

```

## Adding to a NixOS Flake

### 1. Add input to your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    ncalayer.url = "github:ndenissov/ncalayer-nix";
    ncalayer.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ncalayer, ... }: {
    nixosConfigurations.myhostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit ncalayer; };
      modules = [
        ./configuration.nix
      ];
    };
  };
}

```

### 2. Add package to `configuration.nix`:

```nix
{ pkgs, ncalayer, ... }:

{
  # Required for hardware crypto-tokens (e.g., Kaztoken)
  services.pcscd.enable = true;

  environment.systemPackages = [
    ncalayer.packages.${pkgs.system}.default
  ];
}

```

Or via Home Manager (`home.packages = [ ncalayer.packages.${pkgs.system}.default ];`).

## Adding to NixOS (Without Flakes)

If you are not using Nix Flakes, you can import the package using `fetchTarball` in your `configuration.nix`:

```nix
{ pkgs, ... }:

let
  ncalayer = import (builtins.fetchTarball "https://github.com/ndenissov/ncalayer-nix/archive/main.tar.gz") { inherit pkgs; };
in
{
  # Required for hardware crypto-tokens (e.g., Kaztoken)
  services.pcscd.enable = true;

  environment.systemPackages = [
    ncalayer
  ];
}
```
