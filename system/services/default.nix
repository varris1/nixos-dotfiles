{
  imports = [
    ./avahi
    ./locate
    ./pipewire
    ./podman
    ./printing
    ./udev
    ./xdg-portal
  ];

  services = {
    blueman.enable = true;
    flatpak.enable = true;
    # fwupd.enable = true;
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
