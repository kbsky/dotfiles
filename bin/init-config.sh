#!/bin/sh
# General
cd
echo "## Init and update submodules"
git submodule update --init --recursive

# Tag-Highlight
echo "## Clone Tag-Highlight"
hg clone https://bitbucket.org/abudden/taghighlight .vim/bundle/tag-highlight
