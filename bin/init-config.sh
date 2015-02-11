#!/bin/sh
# General
cd
echo "## Init and update submodules"
git submodule update --init --recursive

# git-completion
echo "## Get git-completion"
curl https://raw.github.com/git/git/master/contrib/completion/git-completion.bash > .git-completion.bash

# Tag-Highlight
echo "## Clone Tag-Highlight"
git-hg clone https://bitbucket.org/abudden/taghighlight .vim/bundle/tag-highlight
