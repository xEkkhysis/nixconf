{ lib, config, pkgs, ... }:
{
  nixpkgs.hostPlatform = "x86_64-linux";

  my.desktop.variant = "sway";  # or "cosmic"
  my.desktop.login   = "gdm";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.tom = {
      imports =
        [
          ../../home/common.nix
          ../../home/zsh-omz.nix
          ../../home/alacritty.nix
        ]
        ++ lib.optionals (config.my.desktop.variant == "sway")   [ ../../home/sway.nix ]
        ++ lib.optionals (config.my.desktop.variant == "cosmic") [ ../../home/cosmic.nix ];
    };
  };
}

