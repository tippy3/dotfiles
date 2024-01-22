#!/usr/bin/env bash
set -e

repo_dir="$(cd "$(dirname "$0")" && pwd)"

ln -sf $repo_dir/.gitconfig ~/.gitconfig
ln -sf $repo_dir/.gitignore_global ~/.gitignore_global
