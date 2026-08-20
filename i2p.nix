{ inputs, config, pkgs, lib, ... }:

{
  services.i2pd = {
    enable = true;
  };

  # Because nixos unstable
  environment.etc."i2pd/i2pd.conf".text = ''
    [http]
    enabled = true
    address = 127.0.0.1
    port = 7070

    [httpproxy]
    enabled = true
    address = 127.0.0.1
    port = 4444

    [socksproxy]
    enabled = true
    address = 127.0.0.1
    port = 4445

    [sam]
    enabled = true
    address = 127.0.0.1
    port = 7656
  '';

  # Force the systemd service to use our /etc/i2pd/i2pd.conf
  systemd.services.i2pd.serviceConfig.ExecStart = lib.mkForce "${pkgs.i2pd}/bin/i2pd --conf=/etc/i2pd/i2pd.conf --service";
}
