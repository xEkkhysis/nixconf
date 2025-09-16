{ pkgs, ... }:
{
  nixpkgs.hostPlatform = "x86_64-linux";
  # Inherit base + headless module for SSH server
}
