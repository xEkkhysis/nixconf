{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption mapAttrs types;

  cfg = config.profiles.storage.btrfs;

  subvolumeOption = types.submodule ({ name, ... }: {
    options = {
      mountpoint = mkOption {
        type = types.str;
        description = "Mount point for the subvolume ${name}.";
      };

      mountOptions = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Additional mount options for the subvolume ${name}.";
      };
    };
  });

  buildSubvolume = name: subvol: {
    inherit (subvol) mountpoint;
    mountOptions = cfg.mountOptions ++ subvol.mountOptions;
  };

  subvolumeMounts = mapAttrs buildSubvolume cfg.subvolumes;
in {
  options.profiles.storage.btrfs = {
    enable = mkEnableOption "Btrfs layout provisioned through disko.";

    device = mkOption {
      type = types.str;
      default = "/dev/nvme0n1";
      example = "/dev/nvme0n1";
      description = ''
        Block device that should receive the operating system installation.
      '';
    };

    diskName = mkOption {
      type = types.str;
      default = "main";
      description = "Identifier used for the primary installation disk.";
    };

    esp = {
      start = mkOption {
        type = types.str;
        default = "1M";
        description = "Starting offset of the EFI System Partition.";
      };

      end = mkOption {
        type = types.str;
        default = "1024M";
        description = "End offset of the EFI System Partition.";
      };

      type = mkOption {
        type = types.str;
        default = "EF00";
        description = "GPT type identifier for the EFI System Partition.";
      };

      priority = mkOption {
        type = types.int;
        default = 1;
        description = "Partition priority for the EFI System Partition.";
      };

      mountpoint = mkOption {
        type = types.str;
        default = "/boot";
        description = "Mount point for the EFI System Partition.";
      };

      mountOptions = mkOption {
        type = types.listOf types.str;
        default = [ "umask=0077" ];
        description = "Mount options used for the EFI System Partition.";
      };
    };

    mountOptions = mkOption {
      type = types.listOf types.str;
      default = [ "compress=zstd" "noatime" ];
      description = "Base mount options applied to all managed subvolumes.";
    };

    btrfs = {
      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [ "-f" ];
        description = "Extra arguments passed to mkfs.btrfs for the system partition.";
      };

      mountpoint = mkOption {
        type = types.str;
        default = "/.disko-root";
        description = "Temporary mount point used by disko during deployment.";
      };
    };

    partition = {
      name = mkOption {
        type = types.str;
        default = "NixOS";
        description = "Name of the primary Linux partition.";
      };

      start = mkOption {
        type = types.str;
        default = cfg.esp.end;
        description = "Starting offset of the primary Linux partition.";
      };

      end = mkOption {
        type = types.str;
        default = "100%";
        description = "End offset of the primary Linux partition.";
      };

      type = mkOption {
        type = types.str;
        default = "8300";
        description = "GPT type identifier for the primary Linux partition.";
      };
    };

    subvolumes = mkOption {
      type = types.attrsOf subvolumeOption;
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

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.device != "";
        message = "profiles.storage.btrfs.device cannot be empty.";
      }
    ];

    disko.devices.disk.${cfg.diskName} = {
      type = "disk";
      device = cfg.device;
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            start = cfg.esp.start;
            end = cfg.esp.end;
            priority = cfg.esp.priority;
            name = "ESP";
            type = cfg.esp.type;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = cfg.esp.mountpoint;
              mountOptions = cfg.esp.mountOptions;
            };
          };

          "${cfg.partition.name}" = {
            start = cfg.partition.start;
            end = cfg.partition.end;
            name = cfg.partition.name;
            type = cfg.partition.type;
            content = {
              type = "btrfs";
              extraArgs = cfg.btrfs.extraArgs;
              mountpoint = cfg.btrfs.mountpoint;
              subvolumes = subvolumeMounts;
            };
          };
        };
      };
    };
  };
}
