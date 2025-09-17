{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    warn-dirty = false;
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  time.timeZone = "Europe/Berlin";
  system.stateVersion = "24.05";

  networking.networkmanager.enable = true;
  services.resolved.enable = true;

  virtualisation.docker.enable = true;

  users.users.tom = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    initialPassword = "test";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = [ pkgs.bashInteractive pkgs.zsh ];

  environment.systemPackages = with pkgs; [
    nano vim git curl wget
    ripgrep fd eza bat jq yq tree
    zip unzip p7zip rsync ncdu btop htop
    parted pciutils usbutils lshw
    direnv nix-direnv
    screen
    man-db man-pages man-pages-posix
    docker docker-compose
    openssh
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  hardware.bluetooth.enable = true;
  services.printing.enable = true;
  services.flatpak.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
