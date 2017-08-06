FROM debian:jessie
MAINTAINER Christopher Bunn

RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    build-essential \
    curl \
    debhelper \
    dh-exec \
    dh-systemd \
    dh-python \
    dstat \
    gcc \
    git \
    htop \
    ifstat \
    iotop \
    libevent-dev \
    libtool \
    linux-tools \
    locales \
    lsof \
    make \
    man-db \
    moreutils \
    ncurses-dev \
    net-tools \
    netcat \
    pkg-config \
    python \
    python-setuptools \
    strace \
    sudo \
    sysstat \
    tar \
    tmux \
    tcpdump \
    unzip \
    vim \
    wget \
    zsh

# Set locale info for tmux's (and others) benefit
RUN echo 'en_US UTF-8' > /etc/locale.gen
RUN locale-gen

# install pip
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
RUN rm get-pip.py

# install golang 1.8.3
RUN wget https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.8.3.linux-amd64.tar.gz
RUN rm go1.8.3.linux-amd64.tar.gz
RUN echo "export GOPATH=\"/gocode\"" >> /etc/bash.bashrc
RUN echo "export PATH=$PATH:/usr/local/go/bin:gocode/bin" >> /etc/bash.bashrc

# install bash dotfiles
RUN curl https://raw.githubusercontent.com/mypetyak/dotfiles/bunn/devbox/.bashrc -o /root/.bashrc
RUN curl https://raw.githubusercontent.com/mypetyak/dotfiles/bunn/devbox/.bash_profile -o /root/.bash_profile

# install vim dotfile
RUN curl https://raw.githubusercontent.com/mypetyak/dotfiles/bunn/devbox/.vimrc -o /root/.vimrc

# install vim plugins
RUN git clone https://github.com/gmarik/Vundle.vim.git /root/.vim/bundle/Vundle.vim
RUN vim +PluginInstall +qall

# install tmux doftile
RUN wget -O /etc/tmux.conf https://raw.githubusercontent.com/mypetyak/dotfiles/bunn/devbox/.tmux.conf

# set vi mode
RUN echo "set -o vi" >> /etc/bash.bashrc

ENTRYPOINT /usr/bin/tmux
