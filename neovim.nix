{ pkgs }:

{
    packages = with pkgs; [
        neovim
        ripgrep
        fd
    ];
    shellHook = ''
    echo "Welcome to your Neovim dev shell!"
    echo "If this is the first time, cloning dotfiles..."

    if [ ! -d "$HOME/.config/nvim" ]; then
      echo "Cloning your Neovim config..."
      git clone https://github.com/LeonardoBevilacqua/nvShadow.git $HOME/.config/nvim
    else
      echo "Neovim config already exists at ~/.config/nvim"
    fi
    '';
}
