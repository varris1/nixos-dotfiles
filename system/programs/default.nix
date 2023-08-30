{ pkgs, ... }:
{
  programs = {
    dconf.enable = true;
    fish.enable = true;
    hyprland.enable = true;
    kdeconnect.enable = true;
    ssh.startAgent = true;
    steam.enable = true;
  };
  chaotic.steam.extraCompatPackages = with pkgs; [ luxtorpeda proton-ge-custom ];
}
