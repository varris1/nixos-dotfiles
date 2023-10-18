  {
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
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    openssh.enable = true;
    udisks2.enable = true;

    fstrim = {
      enable = true;
      interval = "weekly";
    };
  };
}
