#!/usr/bin/env bash
set -e

email="26988793+tippy3@users.noreply.github.com"
keyname="github"

rm -f ~/.ssh/$keyname
rm -f ~/.ssh/$keyname.pub
rm -f ~/.ssh/config

ssh-keygen -t ed25519 -f ~/.ssh/$keyname -N "" -C $email

echo "Host github.com" >> ~/.ssh/config
echo "  IdentityFile ~/.ssh/$keyname" >> ~/.ssh/config

echo "Publick key:"
cat ~/.ssh/$keyname.pub
