{pkgs, ...}: {
  imports = [
    ./avahi
    ./locate
    ./pipewire
    ./printing
    ./udev
    ./xdg-portal
  ];

  services = {
    blueman.enable = true;
    flatpak.enable = true;
    fwupd.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    irqbalance.enable = true;
    openssh.enable = true;
    udisks2.enable = true;

    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };

    fstrim = {
      enable = true;
      interval = "weekly";
    };
  };
}
