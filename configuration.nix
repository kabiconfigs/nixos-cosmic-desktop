# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
     ./desktop.nix  
     ./hardware-configuration.nix  
     ./networking.nix
    ];

  documentation.enable = false;
  
  services.displayManager.cosmic-greeter = {
   enable = true; 
   package = pkgs.cosmic-greeter;
  };
  
  services.desktopManager.cosmic = {
   enable = true;
   xwayland.enable = true;
  };

  fonts = {
   enableDefaultPackages = true;
    packages = with pkgs; [
     ubuntu_font_family
     nerd-fonts.jetbrains-mono
     nerd-fonts.liberation
     nerd-fonts.droid-sans-mono
     nerd-fonts.dejavu-sans-mono
    ];
  };

  environment.systemPackages =  with pkgs; [
   cosmic-ext-tweaks
   libcosmicAppHook
   examine
   tasks
   cosmic-ext-tweaks
   (lib.lowPrio cosmic-comp)
   drm_info
   quick-webapps
   nano
   wget
   rsync
   btop
   curl
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      openssl
      curl
      glib
      util-linux
      glibc
      icu
      libunwind
      libuuid
      zlib
      libsecret
      # graphical
      freetype
      libglvnd
      libnotify
      SDL2
      vulkan-loader
      gdk-pixbuf
      xorg.libX11
    ];
  };

  services.flatpak.enable = true;
  services.gnome.gnome-keyring.enable = true;
  
  environment.sessionVariables = {
   NIX_AUTO_RUN = "1";
   NIXPKGS_ALLOW_UNFREE = "1";
   MOZ_ENABLE_WAYLAND = "1";
   MOZ_ENABLE_XINPUT2 = "1";
   MOZ_DISABLE_RDD_SANDBOX = "1";
   NIXOS_OZONE_WL = "1";
   _JAVA_AWT_WM_NONEREPARENTING = "1";
   COSMIC_DATA_CONTROL_ENABLED = "1";
   XDG_DESKTOP_DIR = "$HOME/Desktop";
   XDG_DOCUMENTS_DIR = "$HOME/Documents";
   XDG_DOWNLOAD_DIR = "$HOME/Downloads";
   XDG_MUSIC_DIR = "$HOME/Music";
   XDG_PICTURES_DIR = "$HOME/Pictures";
   XDG_PUBLICSHARE_DIR = "$HOME/Public";
   XDG_TEMPLATES_DIR = "$HOME/Templates";
   XDG_VIDEOS_DIR = "$HOME/Videos";
   XDG_CONFIG_HOME = "$HOME/.config";
  };

   xdg.portal = {
     enable = true;
     xdgOpenUsePortal = true;
     extraPortals = with pkgs; [
      xdg-desktop-portal-cosmic
     ];
      config = {
       common = {
       default = [ "cosmic" ];
      };
    };
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
   console = {
     font = "Lat2-Terminus16";
     keyMap = "us";
   #  useXkbConfig = true; # use xkb.options in tty.
   };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.pipewire = {
   enable = true;
   alsa = {
    enable = true;
    support32Bit = true;
   };
    wireplumber.enable = true;
    pulse.enable = true;
    jack.enable = true;
   };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  users.defaultUserShell = pkgs.bash;

  users.users.kabi = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
   };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
   programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
    { domain = "*"; type = "-"; item = "nofile"; value = "unlimited"; }
    { domain = "*"; type = "-"; item = "nproc"; value = "unlimited"; }
   ];
  
  nix = {
   settings = {
    auto-optimise-store = true;
    cores = 8;
    max-jobs = "auto";
    system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-znver4" ];
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
     "https://nix-community.cachix.org"
     "https://cache.nixos.org/"
     "https://ezkea.cachix.org"
    ];
    trusted-public-keys = [
     "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
     "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
    ];
   };
    gc = {
    automatic = true;
    dates = "*-*-1,4,7,10,13,16,19,22,25,28,31 00:00:00";
    options = "--delete-older-than 7d";
   };
 };      
 users.extraGroups."nix-serve".members = [ "*" ];

 system.stateVersion = "25.11";
}

