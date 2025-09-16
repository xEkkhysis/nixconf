{ lib, config, pkgs, ... }:
{
  nixpkgs.hostPlatform = "x86_64-linux";

  # Switch here: "sway" or "cosmic"; login: "gdm" (default)
  my.desktop.variant = "sway";
  my.desktop.login = "gdm";

  # Desktop user apps & configs via Home-Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.tom = { ... }:
      lib.mkMerge [
        (import ../../home/common.nix)
        (import ../../home/zsh-omz.nix)
        (import ../../home/alacritty.nix)
        (lib.mkIf (config.my.desktop.variant == "sway")   (import ../../home/sway.nix))
        (lib.mkIf (config.my.desktop.variant == "cosmic") (import ../../home/cosmic.nix))
      ];
  };
}
