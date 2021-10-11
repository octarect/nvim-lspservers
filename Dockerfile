FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN set -x \
 && apt-get update \
 && apt-get install -y git ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip

RUN set -x \
 && git clone https://github.com/neovim/neovim \
 && cd neovim \
 && make CMAKE_BUILD_TYPE=RelWithDebInfo \
 && make install

# Plugins
RUN set -x \
 && mkdir -p $HOME/.local/share/nvim/site/pack/vendor/start \
 && cd $HOME/.local/share/nvim/site/pack/vendor/start \
 && git clone https://github.com/nvim-lua/plenary.nvim.git \
 && git clone https://github.com/neovim/nvim-lspconfig

# go get
RUN set -x \
 && apt install -y software-properties-common \
 && add-apt-repository ppa://longsleep/golang-backports \
 && apt update \
 && apt install -y golang-go

# npm
RUN set -x \
 && curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
 && apt-get install -y --no-install-recommends nodejs

# ruby bundler
RUN set -x \
 && apt-get install -y --no-install-recommends ruby ruby-dev \
 && gem install bundler

# pip
RUN set -x \
 && apt install -y python3 python3-pip python3-venv

# erlang
RUN set -x \
 && apt install -y erlang-base erlang-asn1 erlang-public-key erlang-ssl erlang-inets erlang-eunit erlang-dev erlang-parsetools \
 && curl -L https://github.com/erlang/rebar3/releases/download/3.13.3/rebar3 -o /usr/local/bin/rebar3 \
 && chmod +x /usr/local/bin/rebar3

CMD ["/bin/bash"]
