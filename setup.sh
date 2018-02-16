#!/usr/bin/env bash

# this one can get divisive :/
brew cask install vagrant

# you may already have this
brew cask install virtualbox

# this is unfortunately just the client; LXD doesn't currently run outside of Linux
brew install lxc

# alternatively this comes with the gcloud SDK
brew install kubectl