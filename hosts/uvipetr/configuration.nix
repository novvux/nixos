# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.kernelModules = [
    "dm-cache-default" # when using volumes set up with lvmcache
  ];

  fileSystems."/storage" =
    { device = "/dev/storage/storage";
      fsType = "xfs";
    };

  fileSystems."/cache" =
    { device = "/dev/nvme0n1p4";
      fsType = "xfs";
    };

  networking.hostName = "uvipetr"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Virtualization and containers
  virtualisation.docker = {
    enable = true;
  };

  # For azkaban.nix
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true; # Recommended for easier permission management
      
      # Keep swtpm if you want to emulate a TPM chip for the VM
#      swtpm.enable = true; 
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.admin = {
    isNormalUser = true;
    description = "admin";
    extraGroups = [ "networkmanager" "wheel" "minecraft" "torrent" "docker" "tty" "libvirtd" ];
    packages = with pkgs; [];
  };

  users.users.amoeba = {
    isNormalUser = true;
    description = "@echoamoeba_bot";
    extraGroups = [ "wheel" "minecraft" "tty" ];
    packages = with pkgs; [
      nvi
    ];
  };

  users.users.juzeppeverdi = {
    isNormalUser = true;
    extraGroups = [ "docker" ];
    packages = with pkgs; [
      nvi
      jdk25
      maven
      python314
      python314Packages.pip
      python314Packages.pandas 
      python314Packages.matplotlib 
      python314Packages.numpy 
      python314Packages.seaborn 
      python314Packages.scipy
    ];
  };

  users.users.LaSto4ka21 = {
    isNormalUser = true;
    extraGroups = [ "docker" "tty" "minecraft" ];
    packages = with pkgs; [
      nvi
    ];
  };

  users.users.Mitsuki = {
    isNormalUser = true;
    description = "@justnikki_s";
    extraGroups = [ "docker" "tty" ];
    packages = with pkgs; [
      nvi
    ];
  };

  # Service users
  users.users.torrent = {
    isSystemUser = true;
    group = "torrent";
  };

  users.groups.torrent = {}; 
 
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.settings.auto-optimise-store = true;

  nix.settings.trusted-users = [ "root" "admin" ];

  nix.settings.min-free = "2G";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    fastfetch
    btop    
    fan2go
    lm_sensors
    pciutils
    steamcmd
    tmux
    rcon-cli
    
    git
    sops
    age
    ssh-to-age
  ];

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;

    age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];

#    sops.templates."beszel-agent.env" = {
#      owner = "beszel-agent";
#      group = "beszel-agent";
#      mode = "0400";

#      content = ''
#        KEY=${config.sops.secrets."beszel-agent-key"}
#      '';
#    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
