#!/bin/sh
BASEDIR=`readlink -f $0 | xargs dirname`

# Tag-Highlight
git-hg clone https://bitbucket.org/abudden/taghighlight $BASEDIR/tag-highlight

