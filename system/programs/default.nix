{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./nix-ld
  ];

  programs = {
    adb.enable = true;
    ccache = {
      enable = true;
      packageNames = ["openmw"];
    };
    dconf.enable = true;
    gamescope = {
      enable = true;
      # capSysNice = true;
      package = inputs.chaotic-nyx.packages.${pkgs.system}.gamescope_git;
    };
    fish.enable = true;
    hyprland.enable = true;
    kdeconnect.enable = true;
    ssh.startAgent = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };
  chaotic.steam.extraCompatPackages = with pkgs; [luxtorpeda proton-ge-custom];
}
