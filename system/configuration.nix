{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./hardware
    ./programs
    ./services
  ];

  boot = {
    tmp.useTmpfs = true;

    kernel.sysctl."vm.max_map_count" = 16777216; #Star Citizen crash fix

    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = ["i2c-dev" "i2c-piix4"];
    kernelParams = [
      "amdgpu.ppfeaturemask=0xffffffff"
      "net.ifnames=0"
      "amd_pstate.shared_mem=1"
      "amd_pstate=active"
      # "video=DP-1:2560x1440@144"
      # "video=DP-2:2560x1440@144"
    ];

    loader = {
      efi = {
        canTouchEfiVariables = true;
      };

      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        consoleMode = "max";
      };
    };
  };

  powerManagement.cpuFreqGovernor = "schedutil";

  networking = {
    hostName = "terra"; # Define your hostname.
    dhcpcd.enable = true;
    firewall.enable = false;
    extraHosts = ''
      192.168.0.18 steam.deck
      127.0.0.1 modules-cdn.eac-prod.on.epicgames.com
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
          users = ["manuel"];
          keepEnv = true;
          persist = true;
        }
      ];
    };
  };

  users.users.manuel = {
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
      nvtop-amd
      openrgb
      p7zip
      pciutils
      sassc
      ripgrep
      unrar
      unzip
      usbutils
      ydotool
    ];
  };

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  systemd.user.extraConfig = ''
    # needed for xdg-open to find the default browser. Why the fuck do I even need to do that?
    DefaultEnvironment="PATH=/etc/profiles/per-user/manuel/bin:/run/current/system/sw/bin"

    #Systemd is a meme. This is the proof
    DefaultTimeoutStopSec=10s
  '';

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

  system.stateVersion = "23.05";
}
