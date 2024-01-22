# dotfiles

### git clone

まずはSSHキーを作る

```zsh
curl -sf https://raw.githubusercontent.com/tippy3/dotfiles/main/init_github.sh | sh -
```

出力された公開鍵をGitHubに登録し、それを使ってcloneする

```zsh
cd ~/Documents/tippy3
git clone git@github.com:tippy3/dotfiles.git
cd dotfiles
```

`private/`は個人情報を含むのでgit管理していない。自力でコピーする

### 各スクリプトの使い方

```zsh
# シンボリックリンクの作成
./create_link.sh
# macOSの設定
./defaults.sh
```

### Brewfileの使い方

```zsh
# Homebrewのインストール
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# ~/.Brewfileを使ってbrew install
brew bundle --global
```

### GitHub用のGPGキーの作成

```zsh
# GPGキーの作成
# ECC, Curve 25519, 無期限
# 名前とメールアドレスはGitHubのもの。コメントとパスワードは空
LANG=C gpg --full-gen-key
# 公開鍵をクリップボードにコピーしてGitHubに登録
gpg -a --export C6E58267D8785108F1408B4BD88ED59EBA88F15B | pbcopy
```
