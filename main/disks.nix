{ inputs, config, pkgs, ... }:

{
  fileSystems."/media/DIMON" = { 
    device = "/dev/disk/by-label/DIMON";
    fsType = "ext4";
  };

  fileSystems."/media/S-1" ={
    device = "/dev/disk/by-label/S-1";
    fsType = "btrfs";
    options = [ "noatime" "compress-force=zstd:1" "space_cache=v2" ];
  };

  fileSystems = {
    "/".options = [ "compress=zstd" ];
  #  "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "noatime" "compress-force=zstd:1" "autodefrag" "space_cache=v2" ];
  #  "/swap".options = [ "noatime" ];
  };

  services.beesd.filesystems = {
    nixstore = {
      spec = "/nix";
      hashTableSizeMB = 256;
    };
  };
}
