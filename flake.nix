{
  description = "Portable NixOS: desktop/headless with Sway↔COSMIC, GDM, Zsh+OMZ, Docker, UFW";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, agenix, disko, nur, ... }:
  let
    mkSystem = system: modules:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit self nixpkgs home-manager agenix disko nur; };
        modules = modules;
      };
  in {
    nixosConfigurations = {
      desktop = mkSystem "x86_64-linux" [
        ./modules/base.nix
        ./modules/desktop.nix
        ./hosts/desktop
        home-manager.nixosModules.home-manager
        # agenix.nixosModules.default   # enable when you add secrets
        # disko.nixosModules.disko      # enable only for bare metal installs
      ];

      headless = mkSystem "x86_64-linux" [
        ./modules/base.nix
        ./modules/headless.nix
        ./hosts/headless
        # agenix.nixosModules.default
        # disko.nixosModules.disko
      ];
    };
  };
}
