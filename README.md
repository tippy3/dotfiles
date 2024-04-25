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

[private/](./private)は個人情報を含むのでgit管理していない。自力でコピーする。ファイル一覧は[private/.gitignore](./private/.gitignore)を参照

### 各スクリプトの使い方

```zsh
# シンボリックリンクの作成
./create_link.sh
# macOSの設定
./defaults.sh
```

### Homebrew (.Brewfile)

```zsh
# Homebrewのインストール
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# ~/.Brewfileにあるものをすべてinstall
alias bb='brew bundle --global'
bb -v
#  ~/.Brewfileにないものをすべてuninstall
bb cleanup -f
# アップデートのチェック
bb check
```

### asdf (.tool-versions)

```zsh
# .tool-versionsにあるものをすべてinstall
asdf install
# pluginがない場合はinstallが必要
asdf plugin add kubectl
# pluginのアップデート
asdf plugin update --all
# pluginの検索
asdf plugin list all | grep kubectl
# .tool-versionsへの追加
asdf global kubectl 1.25.16
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

### その他メモ

- VSCodeの設定は公式の同期機能を使用
  - https://code.visualstudio.com/docs/editor/settings-sync
  - GitHubアカウントを使用
