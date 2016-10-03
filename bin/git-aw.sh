#!/bin/bash
# Wrapper for git aliases that need to define environment variables while
# still running in the current directory.

# TODO: stop doing that and use another way to tell vimpager/fugitive what's
# going on
export GIT_DIR=$(realpath .git)
export GIT_WORK_TREE=$(realpath .)
# Note: no need to check that GIT_PREFIX is set; cd does nothing when passed
# an empty string.
cd "$GIT_PREFIX"
git "$@"
