{ config, pkgs, inputs, ... }:

{
  home.username = "novvux";
  home.homeDirectory = "/home/novvux";

  nixpkgs.config.allowUnfree = true;

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  #services.polkit-gnome.enable

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    helix # Text editor

    ghidra
    dig

    krita
    libreoffice-stable

    osu-lazer-bin
    
    #misc
    cowsay
    file
    which
    tree
    gawk

    # noctalia widgets dependencies
    jq
    wlr-randr    
    smartmontools
    nvtopPackages.nvidia
    awww

    # chat
    gajim

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring
  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "novvux";
        email = "dimitrirodionow@yandex.ru";
      };
    };
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    presets = [ "jetpack" ];
/*    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };*/
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    shellAliases = {
      rb = "sudo nixos-rebuild switch";
      hb = "home-manager switch -b backup";
    };
  };

  programs.tmux = {
    enable = true;
    mouse = true;
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "26.05";
}
