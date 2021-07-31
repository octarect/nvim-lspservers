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
 && cd /opt \
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
 && apt install -y --no-install-recommends nodejs npm

CMD ["/bin/bash"]
