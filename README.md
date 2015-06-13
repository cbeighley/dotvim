Installation
============

Clone the repo:

    git clone git://github.com/cbeighley/dotvim.git ~/.vim

Create symlinks:

    ln -s ~/.vim/vimrc ~/.vimrc

Switch to the `~/.vim` directory, and fetch submodules:

    cd ~/.vim
    git submodule init
    git submodule update

Add a plugin
============

    git submodule add https://github.com/foo/bar.git bundle/bar
    git add .gitmodules bundle/bar
    git commit

