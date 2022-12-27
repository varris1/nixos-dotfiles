# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  boot = {
    kernelParams =
      [ "amdgpu.ppfeaturemask=0xffffffff" ];

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };

      grub = {
        enable = true;
        useOSProber = false;
        efiSupport = true;
        device = "nodev";
      };

      grub2-theme = {
        enable = true;
        theme = "stylish";
        screen = "2k";
      };
    };

    initrd.availableKernelModules = [ "amdgpu" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "i2c-dev" "i2c-piix4" ];
  };

  powerManagement.cpuFreqGovernor = "schedutil";

  networking = {
    hostName = "terra"; # Define your hostname.
    networkmanager.enable = true;
    firewall.checkReversePath = false;
    firewall.enable = false;

    extraHosts = ''
      192.168.0.17 steam.deck
    '';

  };

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_NUMERIC = "de_AT.UTF-8";
      LC_TIME = "de_AT.UTF-8";
      LC_MONETARY = "de_AT.UTF-8";
      LC_MEASUREMENT = "de_AT.UTF-8";
      LC_IDENTIFICATION = "de_AT.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us-acentos";
  };

  hardware.opengl = {
    enable = true;
    package = pkgs.mesa-git.drivers;
    package32 = pkgs.pkgsi686Linux.mesa-git.drivers;
    extraPackages = [ pkgs.libvdpau-va-gl ];

    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.steam-hardware.enable = true;

  hardware.bluetooth.enable = true;

  # Enable sound.
  sound.enable = true;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.blueman.enable = true;

  services.gvfs.enable = true;

  services.flatpak.enable = true;

  services.locate = {
    enable = true;
    locate = pkgs.plocate;
    localuser = null;
    prunePaths = lib.mkOptionDefault [ ];
    interval = "hourly";
  };

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  services.udisks2.enable = true;

  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [{
        users = [ "manuel" ];
        keepEnv = true;
        persist = true;
      }];
    };
    polkit.enable = true;
  };

  programs.fish.enable = true;

  programs.ccache = {
    enable = true;
    packageNames = [
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.manuel = {
    isNormalUser = true;
    extraGroups = [
      "audio"
      "games"
      "geoclue"
      "input"
      "networkmanager"
      "nm-openvpn"
      "users"
      "video"
      "wheel"
    ];
    shell = pkgs.fish;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = [
      pkgs.git
      pkgs.links2
      pkgs.ripgrep
      pkgs.file
      pkgs.fd
      pkgs.htop
      pkgs.openrgb
      pkgs.unzip
      pkgs.unrar
      pkgs.p7zip
    ];
    binsh = "${pkgs.dash}/bin/dash";
  };

  # List services that you want to enable:
  services.udev.packages = [ pkgs.openrgb ];

  programs.dconf.enable = true;

  programs.kdeconnect.enable = true;

  services.geoclue2 = {
    enable = true;
    appConfig."gammastep" = {
      isAllowed = true;
      isSystem = false;
    };
  };

  services.gnome.gnome-keyring.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  programs.ssh = {
    startAgent = true;
  };

  services.openssh = {
    enable = true;
  };

  services.printing = {
    enable = true;
    drivers = [ pkgs.cnijfilter2 ];
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  services.transmission = {
    enable = true;
    user = "manuel";
    openFirewall = true;
  };

  services.fwupd.enable = true;

  #:  services.getty.autologinUser = " manuel ";

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  systemd.user.extraConfig = ''
    # needed for xdg-open to find the default browser
    DefaultEnvironment="PATH=/etc/profiles/per-user/manuel/bin:/run/current/system/sw/bin"
    DefaultTimeoutStopSec=10s
  '';

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';
    gc = {
      persistent = true;
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    settings.auto-optimise-store = true;
  };

  system.stateVersion = "22.05"; # Did you read the comment?
}

