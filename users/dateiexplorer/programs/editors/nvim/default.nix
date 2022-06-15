{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      # Syntax
      vim-nix
      vim-markdown

      # Quality of life
      # Opens document where you left it 
      vim-lastplace

      # Print double quotes/brackets/etc.
      #auto-pairs
      vim-closer

      # See uncommitted changes of file :GitGutterEnable
      vim-gitgutter

      # File Tree
      nerdtree

      # Customization
      papercolor-theme

      # Info bar at bottom
      lightline-vim

      # Indentation lines
      indent-blankline-nvim

      # VimWiki
      vimwiki
    ];

    # Load configuration from a external file
    extraConfig = builtins.readFile ./config/init.vim;
  };
}
