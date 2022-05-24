{ config, pkgs, user, ... }:

{
  imports = [
    ./programs/editors/neovim.nix
  ];

  # Define the username and home directory.
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";

  home.sessionVariables = {
  };

  # Install packages for this user.
  home.packages = with pkgs; [
    # Add user packages here
    
    # CLI tools
    openconnect

    # Graphical programms
    thunderbird
    libreoffice
    gimp
    discord
    vscode
    keepassxc
    musescore
    vlc

    # Add full LaTeX (TeXLive) installation.
    (pkgs.texlive.combine {
        inherit (texlive) scheme-full;
    })

    # Programming tools
    jetbrains.idea-community 
    gradle
  ];

  # Configure git.
  programs.git = {
    enable = true;
    userEmail = "mail@dateiexplorer.de";
    userName = "Justus Röderer";
  };
 
  # Configure go.
  programs.go = {
    enable = true;
  };

  # Configure syncthing.
  services.syncthing = {
    enable = true;
  };

  # Enable home manager.
  programs.home-manager.enable = true;
}
