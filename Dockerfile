FROM ubuntu:22.04

# fd-findはtelescopeのより高速なファイル検索に使うっぽい
RUN apt update && \
    apt-get update && \
    apt install -y curl git ripgrep tar unzip vim wget build-essential nodejs golang-go npm php-xml fd-find

# （途中でlocation聞かれて -y だけでは突破できない）
ENV DEBIAN_FRONTEND=noninteractive
RUN apt install php-cli php-mbstring -y

# neovim v0.9.2 をインストール
RUN wget https://github.com/neovim/neovim/releases/download/v0.9.2/nvim-linux64.tar.gz && \
    tar -zxvf nvim-linux64.tar.gz && \
    mv nvim-linux64/bin/nvim usr/bin/nvim && \
    mv nvim-linux64/lib/nvim usr/lib/nvim && \
    mv nvim-linux64/share/nvim/ usr/share/nvim && \
    rm -rf nvim-linux64 && \
    rm nvim-linux64.tar.gz

# nvim tree-sitter を使うために、tree-sitterをインストールするが
# npm経由だとうまく行かないのでcargo経由でインストールする。
# そのためにrustをインストールする
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"
RUN cargo install tree-sitter-cli

# vue(typescript)のLSPのためにnpmを使うが、aptで入れているnpmは古いので
# バージョン管理のnを使って最新版を入れる（ついでにnodejsも最新版にする）
RUN npm install n -g
RUN n stable
RUN apt purge -y nodejs npm
RUN apt autoremove -y

# composer install  php-cliとphp-mbstringを使っている（らしい）
# インストールに失敗する場合は、hash値が違っている可能性が高いので公式を参考に修正する
# 公式　https://getcomposer.org/download/
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" 
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php 
RUN php -r "unlink('composer-setup.php');"
RUN mv ./composer.phar /usr/bin/composer && chmod +x /usr/bin/composer 

RUN apt install -y locales && \
    locale-gen ja_JP.UTF-8

# 設定ファイルをコピー
COPY /dotfiles /usr/dotfiles
RUN cp -r /usr/dotfiles/config/. ~/.config/

WORKDIR /usr/projects

# 予めneovimを一度起動させておいてプラグインの自動インストールを実行させる
RUN nvim -c 'q'
