{ config, pkgs, user, ... }:

{
  imports = [
    ./programs/editors/nvim
  ];

  # Define the username and home directory.
  home.username = "${user.name}";
  home.homeDirectory = "/home/${user.name}";

  # Define shell variables.
  home.sessionVariables = { };

  # Install packages for this user.
  home.packages = with pkgs; [
    # Add user packages here

    # Often used CLI tools
    ffmpeg
    yt-dlp

    # Often used graphical tools
    keepassxc
    discord
    musescore
    gimp
    vlc
    vscode
  ];

  programs.bash.enable = true;

  # Configure git.
  programs.git = {
    enable = true;
    userEmail = "${user.email}";
    userName = "${user.description}";
  };

  # Configure go.
  programs.go = {
    enable = true;
    goPath = "Dokumente/go";
  };

  # Configure direnv.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Configure syncthing.
  services.syncthing = {
    enable = true;
  };

  # Enable for graphical session management.
  # This is needed to make home.sessionVariables work in graphical sessions,
  # such as XFCE, Plasma or Gnome
  xsession.enable = true;

  # Enable home manager.
  programs.home-manager.enable = true;

  # Theming
  gtk = {
    enable = true;
    theme = {
      name = "Arc-Dark";
      package = pkgs.arc-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      size = 16;
    };
    iconTheme = {
      name = "Tela dark";
      package = pkgs.tela-icon-theme;
    };
  };

  #qt = {
  #  enable = true;
  #  platformTheme = "gtk";
  #};

}
