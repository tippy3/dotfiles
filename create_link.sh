#!/usr/bin/env bash
set -e

repo_dir="$(cd "$(dirname "$0")" && pwd)"

dotfiles="$(ls -F -d .* | grep -v /)"
for dotfile in $dotfiles; do
  ln -sf $repo_dir/$dotfile ~/$dotfile
done
