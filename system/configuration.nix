# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, lib, inputs, ... }:
{
  imports = [
# Include the results of the hardware scan.
    ./hardware-configuration.nix
      #inputs.hyprland.nixosModules.default
  ];

  nixpkgs.config.allowUnfree = true;

  hardware.firmware = [ pkgs.customedid ];

  boot = {
    kernelParams =
      [
      "amdgpu.ppfeaturemask=0xffffffff"
        "drm.edid_firmware=DP-1:edid/edid-EX2780Q.bin"
        "net.ifnames=0"
      ];

    extraModprobeConfig = ''
      options iwlmvm power_scheme=1
      options iwlwifi power_save=0
      '';

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

# initrd.availableKernelModules=sd [ "amdgpu" ];
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "i2c-dev" "i2c-piix4" ];
  };

  powerManagement.cpuFreqGovernor = "schedutil";

  networking = {
    hostName = "terra"; # Define your hostname.
      enableIPv6 = false;

    wireless = {
      enable = true;
      #FORMAT:
      #PSK_HOME = password
      environmentFile = "/etc/nixos/wifi_secrets.conf";

      networks."TP-Link_EDB8" = {
        psk = "@PSK_HOME@";
      };
    };
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

  chaotic.mesa-git.enable = true;
  hardware.opengl = {
    enable = true;
    extraPackages = [ pkgs.libvdpau-va-gl ];

    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.steam-hardware.enable = true;

  hardware.bluetooth.enable = true;
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
  };

# Enable sound.
  sound.enable = true;

  security = {
    audit.enable = false;
    auditd.enable = false;
    polkit.enable = true;
    rtkit.enable = true;
    sudo.enable = false;

    pam.loginLimits = [{
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "262144";
    }];

    doas = {
      enable = true;
      extraRules = [{
        users = [ "manuel" ];
        keepEnv = true;
        persist = true;
      }];
    };
  };

# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.manuel = {
    isNormalUser = true;
    extraGroups = [ "audio" "games" "input" "scanner" "lp" "users" "video" "wheel" ];
    shell = pkgs.fish;
  };

# List packages installed in system profile. To search, run:
# $ nix search wget
  environment = {
    systemPackages = [
      pkgs.bc
      pkgs.distrobox
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

  chaotic.gamescope = {
    enable = true;
    #capSysNice = true;
    session.enable = true;
    package = pkgs.gamescope-git;
  };
  chaotic.linux_hdr.specialisation.enable = true;

# List services that you want to enable:
  programs = {
    dconf.enable = true;
    hyprland.enable = true;
    fish.enable = true;
    kdeconnect.enable = true;
    ssh.startAgent = true;
  };

  services = {
    blueman.enable = true;
    flatpak.enable = true;
    fwupd.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    openssh.enable = true;
    udev.packages = [ pkgs.openrgb ];
    udisks2.enable = true;

    printing = {
      enable = false;
      drivers = [ pkgs.cnijfilter2 ];
    };

    avahi = {
      enable = true;
      nssmdns = true;
    };

    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };


    transmission = {
      enable = true;
      user = "manuel";
      openFirewall = true;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };


    locate = {
      enable = true;
      locate = pkgs.plocate;
      localuser = null;
      prunePaths = lib.mkOptionDefault [ ];
      interval = "hourly";
    };

    fstrim = {
      enable = true;
      interval = "weekly";
    };
  };

  virtualisation.podman.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr.enable = false; #conflict with XDPH if enabled
      extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      ];
  };

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
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      extra-substituters = [
        "https://nyx.chaotic.cx"
      ];
      extra-trusted-public-keys = [
        "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      ];
    };
  };

  system.stateVersion = "22.05"; # Did you read the comment?
}

