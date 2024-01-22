#!/usr/bin/env bash
set -e

# .DS_Storeを作らない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# 隠しファイルを表示する
defaults write com.apple.finder AppleShowAllFiles -bool true

# スクリーンショットの名前を変更する
defaults write com.apple.screencapture name Screenshot

# スクリーンショットの影を消す
defaults write com.apple.screencapture disable-shadow -bool true

# Finderは即時反映したいので再起動
killall Finder
