# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, user, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Linux kernel.
  # Enable the default Linux kernel
  boot.kernelPackages = pkgs.linuxPackages;
  # Lates Linux kernel
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader.
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking.
  # Define your hostname.
  networking.hostName = "devman";
  # Enables wireless support via wpa_supplicant.
  # networking.wireless.enable = true;  

  # Enable networking 
  networking.networkmanager.enable = true;
  # Neccessary for the XFCE desktop to enable nm-applet at startup.
  programs.nm-applet.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so this
  # generated config replicates the default behaviour.
  networking.useDHCP = false;
  # Disable the default interface because it is not always available.
  # networking.interfaces.enp0s13f0u1u4.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # X11
  # Configure the X11 windowing system.
  services.xserver = {
    enable = true;

    displayManager = {
      lightdm.enable = true;
    };

    desktopManager = {
      # Disable xterm as desktopManager
      xterm.enable = false;
      # Enable XFCE.
      xfce.enable = true;
    };
  };

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "altgr-intl";

  # Enable drivers for the wacom tablet.
  services.xserver.modules = [ pkgs.xf86_input_wacom ];
  services.xserver.wacom.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Enable fingerprint support on Framework.
  # https://grahamc.com/blog/nixos-on-framework
  services.fprintd.enable = true;

  # Printing.
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    # Include drivers for the EPSON printer.  
    pkgs.epson-escpr2
  ];

  # Enable automatically printer/scanner detection.
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Sound.
  # Enable sound.
  sound.enable = true;
  # Disable pulseaudio, use pipewire instead
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true

    # use the example sessions manager (no others are packaged yet so this is
    # enabled by default, no need to redefine it in your config for now)
    #media-session.enable = true;
  };


  # User accounts.
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user.name} = {
    isNormalUser = true;
    # As a default value use the username as password.
    # Change this password after first login.
    initialPassword = "${user.name}";
    description = "${user.description}";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "lp"
      "vboxusers"
    ];
  };

  # Packages.
  # Allow unfree packages. 
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix!

    # Often used CLI tools
    wget
    git
    killall
    unzip
    openconnect

    # Often used graphical tools
    firefox
    thunderbird
    libreoffice
    okular
    xfce.xfburn
    libsForQt5.kdenlive

    # XFCE configuration and tools
    xfce.mousepad
    xfce.xfce4-whiskermenu-plugin
    xfce.xfce4-pulseaudio-plugin 
    xfce.thunar-volman

    pavucontrol

    # Add full LaTeX (TeXLive) installation.
    (pkgs.texlive.combine {
      inherit (texlive) scheme-full;
    })

    # Programming tools
    jetbrains.idea-community
    gradle
  ];

  # Nix package manager.
  #nix.package = pkgs.nixUnstable;

  # Use the flakes feature.
  nix.package = pkgs.nixFlakes;

  # This is required when using experimental nix.
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Optimise nix store.
  nix.settings.auto-optimise-store = true;


  # Additional programs.

  # Install java system wide and set the JAVA_HOME path.
  programs.java.enable = true;

  # Virtualization
  # Configure virtualbox.
  virtualisation.virtualbox.host = {
    enable = true;
    # Needed 'unfree' packages enabled. 
    enableExtensionPack = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Bluetooth.
  # https://nixos.wiki/wiki/Bluetooth 
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  # Enable blueman to get the blueman-applet as mentioned in the wiki. 
  services.blueman.enable = true;

  # Flatpak
  services.flatpak.enable = true;
  # Required by flatpak.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}

