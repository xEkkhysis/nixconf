{
  description = "NixOS laptop with COSMIC desktop, foot terminal and disko Btrfs layout.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, disko, ... }:
    let
      inherit (nixpkgs.lib) nixosSystem;
      mkHost = hostModule:
        nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit self; };
          modules = [
            ./modules/nixos/core.nix
            ./modules/nixos/desktop/cosmic.nix
            ./modules/nixos/storage/disko-btrfs.nix
            hostModule
            home-manager.nixosModules.home-manager
            disko.nixosModules.disko
          ];
        };
    in {
      nixosConfigurations.laptop = mkHost ./hosts/laptop.nix;
    };
}
