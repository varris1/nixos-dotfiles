# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  boot = {
    consoleLogLevel = 3;

    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "amdgpu.ppfeaturemask=0xffffffff"
    ];

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };

      grub = {
        enable = true;
        useOSProber = true;
        efiSupport = true;
        device = "nodev";
      };

      grub2-theme = {
        enable = true;
        theme = "vimix";
        screen = "2k";
      };
    };

    initrd.availableKernelModules = [ "amdgpu" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "i2c-dev" "i2c-piix4" ];
  };

  networking.hostName = "terra"; # Define your hostname.

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
    extraPackages = [
      pkgs.libvdpau-va-gl
    ];

    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.steam-hardware.enable = true;

  hardware.bluetooth.enable = true;

  # Enable sound.
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.locate = {
    enable = true;
    locate = pkgs.plocate;
    localuser = null;
    prunePaths = lib.mkOptionDefault [
      "/mnt/btrfs"
    ];
    interval = "hourly";
  };

  security.doas.enable = true;
  security.sudo.enable = false;

  security.doas.extraRules = [{
    users = [ "manuel" ];
    keepEnv = true;
    persist = true;
  }];

  security.polkit.enable = true;

  programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.manuel = {
    isNormalUser = true;
    extraGroups = [ "users" "wheel" "audio" "video" "games" "input" "geoclue" ];
    shell = pkgs.fish;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    links2
    ripgrep
    fd
    htop
    openrgb
  ];
  environment.pathsToLink = [ "/share/zsh" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.udev.packages = [ pkgs.openrgb ];

  programs.dconf.enable = true;

  services.geoclue2 = {
    enable = true;
    appConfig."gammastep".isAllowed = true;
    appConfig."gammastep".isSystem = false;
  };

  services.gnome.gnome-keyring.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
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

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        vt = 1;
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd sway";
      };
      user = "manuel";
    };
  };

  nix.gc = {
    persistent = true;
    automatic = true;
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
    warn-dirty = false
  '';

  system.stateVersion = "22.05"; # Did you read the comment?

}

