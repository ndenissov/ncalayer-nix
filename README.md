# NCALayer Nix Flake

The Nix Flake providing **NCALayer** (the digital signature EDS client for Kazakhstan government portals).

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
