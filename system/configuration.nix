{
  pkgs,
  lib,
  config,
  inputs,
  hostName,
  userName,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./hardware
    ./programs
    ./services
  ];

  boot = {
    tmp.cleanOnBoot = true;

    kernel.sysctl."vm.max_map_count" = 16777216; #Star Citizen crash fix

    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = ["i2c-dev" "i2c-piix4"];
    kernelParams = [
      "amd_pstate.shared_mem=1"
      "amd_pstate=active"

      #quiet boot
      "quiet"
      "splash"
      "vga=current"
      "quiet"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "splash"
    ];

    initrd.verbose = false;
    consoleLogLevel = 0;

    loader = {
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = true;
      };

      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };

      timeout = 10;
    };
  };

  powerManagement.cpuFreqGovernor = "schedutil";

  networking = {
    hostName = "${hostName}"; #hostname declared in flake.nix
    firewall.enable = false;
    networkmanager.enable = true;
    extraHosts = ''
      192.168.0.18 steam.deck
      127.0.0.1 modules-cdn.eac-prod.on.epicgames.com
    '';
    # nameservers = ["94.16.114.254" "94.247.43.254"]; #OpenNIC
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

  # Enable sound.
  sound.enable = true;

  security = {
    audit.enable = false;
    auditd.enable = false;
    polkit.enable = true;
    rtkit.enable = true;
    sudo.enable = false;

    doas = {
      enable = true;
      extraRules = [
        {
          users = ["${userName}"];
          # keepEnv = true;
          persist = true;
          #silence a warning about missing locales
          setEnv = ["LOCALE_ARCHIVE"];
        }
      ];
    };

    wrappers = {
      "wavemon" = {
        source = "${pkgs.wavemon}/bin/wavemon";
        owner = "root";
        group = "root";
        capabilities = "cap_net_admin+eip";
      };
    };
  };

  users.users.${userName} = {
    isNormalUser = true;
    extraGroups = ["audio" "games" "input" "lp" "networkmanager" "scanner" "users" "vboxusers" "video" "wheel"];
    shell = pkgs.fish;
  };

  environment = {
    systemPackages = with pkgs; [
      bc
      cached-nix-shell
      compsize
      distrobox
      fd
      file
      git
      htop
      inotify-tools
      kdiskmark
      links2
      libsForQt5.dolphin
      libsForQt5.kio-extras
      lm_sensors
      nix-search-cli
      nvtop-amd
      openrgb
      p7zip
      pciutils
      pv
      sassc
      socat
      ripgrep
      unrar
      unzip
      usbutils
      wget
      ydotool
    ];
  };

  systemd = {
    extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';

    user.extraConfig = ''
      #Systemd is a meme. This is the proof
      DefaultTimeoutStopSec=10s
    '';

    network = {
      enable = true;
    };

    services = {
      systemd-networkd-wait-online.enable = lib.mkForce false;
    };
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';

    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    gc = {
      persistent = true;
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;
      extra-sandbox-paths = [config.programs.ccache.cacheDir];

      substituters = [
        "https://nyx.chaotic.cx"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  system.stateVersion = "23.11";
}
