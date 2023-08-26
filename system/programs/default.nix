{ pkgs, ... }:
{
  programs.steam.enable = true;
  chaotic.steam.extraCompatPackages = with pkgs; [ luxtorpeda proton-ge-custom ];

  programs = {
    dconf.enable = true;
    hyprland.enable = true;
    fish.enable = true;
    kdeconnect.enable = true;
    ssh.startAgent = true;
  };
}
