{ config, lib, ... }:
let
  cfg = config.profiles.storage.btrfs;
  subvolumeOption = lib.types.submodule ({ name, ... }: {
    options = {
      mountpoint = lib.mkOption {
        type = lib.types.str;
        description = "Mount point for the subvolume ${name}.";
      };

      mountOptions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Additional mount options for the subvolume ${name}.";
      };
    };
  });
  buildSubvolume = name: subvol: {
    inherit (subvol) mountpoint;
    mountOptions = cfg.mountOptions ++ subvol.mountOptions;
  };
  subvolumes = lib.mapAttrs buildSubvolume cfg.subvolumes;
in {
  options.profiles.storage.btrfs = {
    enable = lib.mkEnableOption "Btrfs layout provisioned through disko.";

    device = lib.mkOption {
      type = lib.types.str;
      default = "/dev/nvme0n1";
      example = "/dev/nvme0n1";
      description = ''
        Block device that should receive the operating system installation.
      '';
    };

    mountOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "compress=zstd" "noatime" ];
      description = "Base mount options applied to all managed subvolumes.";
    };

    subvolumes = lib.mkOption {
      type = lib.types.attrsOf subvolumeOption;
      default = {
        "@root" = { mountpoint = "/"; };
        "@home" = { mountpoint = "/home"; };
        "@snapshots" = { mountpoint = "/home/.snapshots"; };
        "@nix" = { mountpoint = "/nix"; };
      };
      description = ''
        Declarative subvolume layout for the Btrfs root partition. Values are
        merged with {option}`profiles.storage.btrfs.mountOptions`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.device != "";
        message = "profiles.storage.btrfs.device cannot be empty.";
      }
    ];

    disko.devices = {
      disk.main = {
        type = "disk";
        device = cfg.device;
        wipeTable = true;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "partition";
              start = "1M";
              end = "1024M";
              priority = 1;
              bootable = true;
              name = "ESP";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            system = {
              type = "partition";
              start = "1024M";
              end = "100%";
              name = "NixOS";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                mountpoint = "/.disko-root";
                subvolumes = subvolumes;
              };
            };
          };
        };
      };
    };
  };
}
