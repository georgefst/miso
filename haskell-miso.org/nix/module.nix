{ options, lib, config, pkgs, ... }:
let
  cfg = config.services.haskell-miso;
in {
   options.services.haskell-miso.enable = lib.mkEnableOption "Enable the haskell-miso.org service";
   config = lib.mkIf cfg.enable {
     systemd.services.haskell-miso = {
       path = with pkgs;
         [ misoPkgs.haskell-miso-runner 
           bash
         ];
       wantedBy = [ "multi-user.target" ];
       script = ''
         ./bin/server +RTS -N -A4M -RTS
       '';
       description = ''
         https://haskell-miso.org
       '';
       serviceConfig = with pkgs.misoPkgs; {
         WorkingDirectory=haskell-miso-runner;
         KillSignal="INT";
         Type = "simple";
         Restart = "on-abort";
         RestartSec = "10";
      };
    };
  };
}
