# dotfiles

### git clone

先にSSH用の鍵を作る

```zsh
./init_github.sh
```

出力された公開鍵をGitHubに登録する

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
