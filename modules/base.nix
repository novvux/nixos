{ pkgs, inputs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  # Create your user on ALL machines
#  users.users.novvux = {
#    isNormalUser = true;
#    extraGroups = [ "wheel" "networkmanager" ];
#    openssh.authorizedKeys.keys = [
#      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI..."
#    ];
#  };

  # Allow your user to use deploy-rs / sudo without password (optional)
#  security.sudo.wheelNeedsPassword = false;

  # Install base packages on ALL machines
  environment.systemPackages = with pkgs; [
    git
    curl
    inputs.deploy-rs.packages.${pkgs.system}.default
  ];
}
