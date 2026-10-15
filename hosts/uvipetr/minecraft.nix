{ config, lib, pkgs, inputs, nix-minecraft, ... }:

let
  authlibInjector = pkgs.fetchurl {
    url = "https://github.com/yushijinhun/authlib-injector/releases/download/v1.2.7/authlib-injector-1.2.7.jar";
    sha256 = "0av58bz0fn7wn9bf7sib62cn4vgkk4mr9mavpn2xiizzmk2lpwga";
  };
in
{
  imports = [ nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    dataDir = "/storage/games/minecraft";
    
    servers.aeronautics = {
      enable = true;
      package = pkgs.neoforgeServers.neoforge-1_21_1;
      serverProperties = {
        motd = "Это сервер. Увы.";
        server-port = 25565;
        max-players = 10;
        gamemode = "survival";
        difficulty = "hard";
        white-list = false;
        enable-command-block = true;
        spawn-protection = 0;
        view-distance = 5;
        simulation-distance = 4;
        allow-flight = true;

        online-mode = false;

        enable-rcon = true;
        # Ну да у вас есть пароль от rcon, а у rcon нет доступа к сети, хехе
        "rcon.password" = "1234eE4321";
      };

      jvmOpts = [
        "-Xms8G" "-Xmx30G"
        #"-XX:+UseG1GC" "-XX:+ParallelRefProcEnabled"
        # https://exa.y2k.diy/garden/jvm-args/
        "-XX:+UseZGC"
#        "-XX:+UseCompactObjectHeaders"
        "-XX:+UseStringDeduplication" "-XX:+ParallelRefProcEnabled" "-XX:+AlwaysPreTouch" "-XX:+PerfDisableSharedMem" "-XX:+ZGenerational" "-XX:-ZUncommit"
        # Inject Ely.by Yggdrasil API at JVM startup
#        "-javaagent:${authlibInjector}=https://authserver.ely.by"
      ];

    };

  };
}
