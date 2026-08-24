# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [ 
    inputs.millennium.overlays.default 
    inputs.nix-cachyos-kernel.overlays.pinned
  ];

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = false;

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
#  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
#  boot.kernelPackages = pkgs.linux_zen;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

#  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;
#  services.desktopManager.plasma6.enable = true;
#  services.displayManager.plasma-login-manager.enable = true;

  programs.mango.enable = true;
#  security.polkit.enable = true;

  xdg.portal = {
    enable = true; # Required for any XDG portal to function
#    wlr.enable = true;
  };

  # For screensharing
  systemd.user.services.xdg-desktop-portal-wlr.environment = {
    PATH = lib.mkForce "${pkgs.wofi}/bin:${pkgs.rofi}/bin:${pkgs.bemenu}/bin:${pkgs.grim}/bin:${pkgs.slurp}/bin:/run/current-system/sw/bin";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us, ru";
    variant = "";
    options = "grp:alt_shift_toggle,caps:escape";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."novvux" = {
    isNormalUser = true;
    description = "novvux";
    extraGroups = [ "networkmanager" "wheel" "plugdev" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      kdePackages.dolphin
      kdePackages.kio-extras
      kdePackages.kio-fuse
      samba
      nfs-utils
      openssh
      sshfs
      avahi
      libmtp
      # thumbnailer needs ffmpeg with unfree codecs
#      ffmpegthumbnailer            # Generates video thumbnails (mp4, mkv, webm, etc.)
#      (ffmpegthumbnailer.override {
#        ffmpeg = pkgs.ffmpeg.override { withUnfree = true; };
#      })
#      kdePackages.ffmpegthumbs
      kdePackages.kdegraphics-thumbnailers
      qt6.qtimageformats
      libheif

      equibop
      materialgram
#      ayugram-desktop
#      zoom-us

      kdePackages.qt6ct
      shared-mime-info
      libavif
      qimgv

#      freecad
      zathura
#      libreoffice-fresh
#      onlyoffice-desktopeditors
#      gram

      qbittorrent
      yt-dlp

#      lutris
#      inputs.freesmlauncher.packages.${system}.freesmlauncher
#      mangohud
#      gamemode

      playerctl
      nwg-look
      adw-gtk3
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };

  programs.steam = {
    enable = true;
    package = pkgs.millennium-steam;
  };

  programs.fish.enable = true;

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  programs.nix-ld.enable = true;

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
 
    # This shit needs 17 GiB of storage to build   
#    packageOverrides = pkgs: {
#      ffmpeg = pkgs.ffmpeg.override {
#        withUnfree = true; 
#        withMetal = false; # Use Metal API on Mac. Unfree and requires manual downloading of files
#        withMfx = false; # Hardware acceleration via the deprecated intel-media-sdk/libmfx. Use oneVPL instead (enabled by default) from Intel's oneAPI.
#        withTensorflow = false; # Tensorflow dnn backend support (Increases closure size by ~390 MiB)
#        withSmallBuild = true; # Prefer binary size to performance.
#        withDebug = false; # Build using debug options
#        withHeadlessDeps = true;
#        withFullDeps = false;
#      };
#    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.settings.auto-optimise-store = true;

  nix.distributedBuilds = true;

  nix.buildMachines = [
    {
      hostName = "192.168.1.7"; # Or hostname
      sshUser = "admin";
      sshKey = "/root/.ssh/id_ed25519";
      systems = [ "x86_64-linux" ]; # MUST match your local architecture
      maxJobs = 6; # Number of cores to use on the remote machine
      speedFactor = 10; # Higher number = Nix prefers this machine over local
    }
  ];

  # Tells the remote machine to download pre-built binaries from the Nix cache 
  # instead of building from source if they are already available.
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    fastfetch
    cmatrix
    pywalfox-native
    libidn2
    alacritty

    zed-editor
    rust-analyzer
    cargo
    rustc
    gcc

    mpv

    btop
    mpv
    papirus-icon-theme
    papirus-folders
    git
    # For screensharing
    wofi
    rofi
    bemenu
    mew
    wlroots
    slurp
    grim
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
