#!/usr/bin/env bash

# Key repeat — fastest rate and shortest delay (below UI minimums)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# iTerm2 — set default profile to the one managed in DynamicProfiles
defaults write com.googlecode.iterm2 "Default Bookmark Guid" "DA7FD4F2-24FF-4BAC-90EA-5AC443F9CF02"
