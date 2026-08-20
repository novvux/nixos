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

  services.desktopManager.gnome.enable = false;
  services.displayManager.gdm.enable = true;

  programs.mango.enable = true;
  security.polkit.enable = true;

  # Screensharing
#  xdg.portal.enable = true;
#  xdg.portal.wlr.enable = true;

  xdg.portal = {
    enable = true; # Required for any XDG portal to function
    wlr.enable = true; # Enables the wlroots portal (required for MangoWM)
    
    # Explicitly prioritize 'wlr' for MangoWM to prevent GNOME's portal from hijacking requests
#    config = {
#      common.default = [ "wlr" "gtk" ];
#      mango.default = lib.mkForce [ "wlr" "gtk" ];
#    };
    
    # Optional but recommended: ensures GTK file dialogs work alongside wlr
#    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us, ru";
    variant = "";
    options = "grp:alt_shift_toggle,caps:escape";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."novvux" = {
    isNormalUser = true;
    description = "novvux";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      equibop
      materialgram
      ayugram-desktop

      kdePackages.qt6ct
      shared-mime-info
      libavif
      qimgv

      freecad
      zathura
      libreoffice-fresh
      onlyoffice-desktopeditors
#      gram

      qbittorrent
      yt-dlp

      lutris
      mangohud
      gamemode

      playerctl
      nwg-look
      adw-gtk3
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.with-cli
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

  programs.nix-ld.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    fastfetch
    pywalfox-native
    libidn2
    alacritty
    zed-editor
    btop
    gnome-tweaks
    mpv
    ffmpeg
    cargo
    wine-staging
    papirus-icon-theme
    papirus-folders
    git
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
