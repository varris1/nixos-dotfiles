{
  imports = [
    ./locate
    ./pipewire
    ./podman
    ./printing
    ./udev
    ./xdg-portal
  ];

  services = {
    avahi.enable = true;
    blueman.enable = true;
    flatpak.enable = true;
    gvfs.enable = true;
    openssh.enable = true;
    udisks2.enable = true;

    fstrim = {
      enable = true;
      interval = "weekly";
    };
  };
}
