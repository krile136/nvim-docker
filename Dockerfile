FROM ubuntu:22.04

# fd-findはtelescopeのより高速なファイル検索に使うっぽい
# 最新のミドルウェアを落とせるようにadd-apt-repositoryを使えるようにする
RUN apt update && \
    apt-get update && \
    apt-get install -y software-properties-common

# 最新のミドルウェアを落とせるようにする
RUN add-apt-repository ppa:longsleep/golang-backports

# ミドルウェアのインストール
# curl  サーバーからデータを転送するためのツール trees-sitterのダウンロードに使用している
# git   バージョン管理ツール
# ripgrep  テキスト検索ツール(telescopeで使用)
# tar   圧縮ファイルの解凍に使用
# unzip 圧縮ファイルの解凍に使用
# vim   ないと不便なエディタ
# wget  ファイルのダウンロードに使用
# build-essential  ビルドに必要なツール
# nodejs  javascriptの実行環境
# golang-go  golangの実行環境
# npm   nodejsのパッケージ管理ツール
# php-xml  phpのxmlパッケージ(phpのLSPで使用していたような？）
# fd-find  ファイル検索ツール(telecopeでより早い検索に使用)
# libunibilium-dev  なくてもneovimは動くが、色がおかしくなる
# openjdk-11-jd java11の実行環境(apexのformatterに必要)
# lualocks luaのパッケージ管理ツール
# lynx テキストブラウザ(Copilot Chatで使用）
# python3-pip pythonのパッケージ管理ツール
# universal-ctags ソースコードのタグ生成ツール(salesforceのプラグイン(sf)でApexジャンプ拡張に使用)
RUN apt update && \
    apt-get update && \
    apt install -y curl git ripgrep tar unzip vim wget build-essential nodejs golang-go npm php-xml fd-find libunibilium-dev openjdk-21-jdk luarocks lynx python3-pip universal-ctags

# （途中でlocation聞かれて -y だけでは突破できない）
ENV DEBIAN_FRONTEND=noninteractive
RUN apt install php-cli php-mbstring -y

# neovim v0.10.4 をインストール
RUN wget https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-x86_64.tar.gz && \
    tar -zxvf nvim-linux-x86_64.tar.gz && \
    mv nvim-linux-x86_64/bin/nvim usr/bin/nvim && \
    mv nvim-linux-x86_64/lib/nvim usr/lib/nvim && \
    mv nvim-linux-x86_64/share/nvim/ usr/share/nvim && \
    rm -rf nvim-linux-x86_64 && \
    rm nvim-linux-x86_64.tar.gz

# nvim tree-sitter を使うために、tree-sitterをインストールするが
# npm経由だとうまく行かないのでcargo経由でインストールする。
# そのためにrustをインストールする
# RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
# ENV PATH="/root/.cargo/bin:$PATH"
# RUN cargo install tree-sitter-cli

# vue(typescript)のLSPのためにnpmを使うが、aptで入れているnpmは古いので
# バージョン管理のnを使って最新版を入れる（ついでにnodejsも最新版にする）
RUN npm install n -g
RUN n stable
RUN apt purge -y nodejs npm
RUN apt autoremove -y

# npmでtree-sitterをインストール
RUN npm install -g tree-sitter-cli

# salesforceのformatterとsaleforce CLIをインストール
RUN npm install --global prettier prettier-plugin-apex @salesforce/cli

# composer install  php-cliとphp-mbstringを使っている（らしい）
# インストールに失敗する場合は、hash値が違っている可能性が高いので公式を参考に修正する
# 公式　https://getcomposer.org/download/
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv ./composer.phar /usr/bin/composer && chmod +x /usr/bin/composer 

# Copilot Chatのトークンカウント用のtiktokenをインストール
RUN pip install tiktoken

# よくわからんがもう一回apt-get updateを実行しないとエラーになってしまう
RUN apt-get update && \
    apt-get install -y locales && \
    locale-gen ja_JP.UTF-8

# 設定ファイルをコピー
COPY /dotfiles /usr/dotfiles
RUN cp -r /usr/dotfiles/config/. ~/.config/

WORKDIR /usr/projects

# 予めneovimを一度起動させておいてプラグインの自動インストールを実行させる
RUN nvim -c 'q'
