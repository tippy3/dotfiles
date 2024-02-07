#!/usr/bin/env bash
set -e

# .DS_Storeを作らない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# 隠しファイルを表示する
defaults write com.apple.finder AppleShowAllFiles -bool true

# スクリーンショット
defaults write com.apple.screencapture name image
defaults write com.apple.screencapture include-date -bool false
defaults write com.apple.screencapture show-thumbnail -bool false
defaults write com.apple.screencapture disable-shadow -bool true

# Finderは即時反映したいので再起動
killall Finder
