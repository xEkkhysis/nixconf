{ nur, lib, pkgs, config, ... }:
{
  nixpkgs.overlays = [ nur.overlay ];
  nixpkgs.config.allowUnfree = true;

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # VM-friendly root so nixos-generators -f qcow works
  fileSystems."/" = {
    fsType = lib.mkForce "ext4";
    device = "/dev/disk/by-label/nixos";
  };

  # Time/locale basics
  time.timeZone = "Europe/Berlin";
  system.stateVersion = "24.05";

  # Networking base
  networking.networkmanager.enable = true;
  services.resolved.enable = true;

  # Use UFW (disable built-in firewall)

  # Docker
  virtualisation.docker.enable = true;

  # Common user (adjust later if you like)
  users.users.tom = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    initialPassword = "test";
  };

  # CLI tool stack (headless + desktop)
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
}
