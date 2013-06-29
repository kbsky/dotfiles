#!/bin/sh
# General
cd
echo "## General submodules update"
git submodule update

# git-completion
echo "## git-completion update"
curl https://raw.github.com/git/git/master/contrib/completion/git-completion.bash > .git-completion.bash

# Tag-Highlight
cd .vim/bundle/tag-highlight
echo "## Tag-Highlight update"
git-hg pull 
