{ nur, lib, pkgs, config, ... }:
{
  nixpkgs.overlays = [ nur.overlays.default ];
  nixpkgs.config.allowUnfree = true;
  
  imports = [
	./disko.nix
     ];

  # Nix settings
  nix.settings = {
    warn-dirty = false;
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
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

  
  # Bootloader
  boot.loader.systemd-boot.enable = true;        # UEFI boot
  boot.loader.efi.canTouchEfiVariables = true;   # write EFI vars

}
