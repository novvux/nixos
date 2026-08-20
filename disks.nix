{ inputs, config, pkgs, ... }:

{
  fileSystems."/media/DIMON" = { 
    device = "/dev/disk/by-label/DIMON";
    fsType = "ext4";
  };

  fileSystems."/media/S-1" ={
    device = "/dev/disk/by-label/S-1";
    fsType = "btrfs";
  };
}
