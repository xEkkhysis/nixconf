{ self, ... }:
{
  networking.hostName = "laptop";
  nixpkgs.hostPlatform = "x86_64-linux";

  i18n = {
    defaultLocale = "de_DE.UTF-8";
    supportedLocales = [
      "de_DE.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
  };

  services.xserver.xkb = {
    layout = "de";
    variant = "nodeadkeys";
    options = "caps:swapescape";
  };

  console.keyMap = "de-latin1-nodeadkeys";

  profiles.storage.btrfs.enable = true;
  profiles.storage.btrfs.device = "/dev/nvme0n1";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.tom = {
      imports = [
        (self + /modules/home/core.nix)
        (self + /modules/home/programs/foot.nix)
        (self + /modules/home/shells/oh-my-zsh.nix)
        (self + /modules/home/desktop/cosmic.nix)
      ];
    };
  };
}
