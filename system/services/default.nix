{
  pkgs,
  config,
  ...
}: {
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
    dbus.implementation = "broker";
    flatpak.enable = true;
    geoclue2.enable = true;
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
