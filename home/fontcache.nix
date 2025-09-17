{ lib, pkgs, ... }:
{
  # Run after HM has linked the generation, as the real user (not /homeless-shelter)
  home.activation.buildFontCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.fontconfig}/bin/fc-cache -r
  '';
}
