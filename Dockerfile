FROM debian:jessie
MAINTAINER Christopher Bunn

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    debhelper \
    dh-exec \
    dh-systemd \
    dh-python \
    gcc \
    git \
    libevent-dev \
    locales \
    make \
    man-db \
    ncurses-dev \
    net-tools \
    netcat \
    python \
    python-setuptools \
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

# install golang 1.7.3
RUN wget https://storage.googleapis.com/golang/go1.7.3.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.7.3.linux-amd64.tar.gz
RUN rm go1.7.3.linux-amd64.tar.gz
RUN echo "export GOPATH=\"/gocode\"" >> /etc/profile
RUN echo "export PATH=$PATH:/usr/local/go/bin:gocode/bin" >> /etc/profile

# install vim dotfile
RUN curl https://raw.githubusercontent.com/mypetyak/dotfiles/master/.vimrc -o /root/.vimrc

# install vim plugins
RUN git clone https://github.com/gmarik/Vundle.vim.git /root/.vim/bundle/Vundle.vim
RUN vim +PluginInstall +qall

# install yab
RUN GOPATH=/gocode /usr/local/go/bin/go get -u -f github.com/yarpc/yab

# set vi mode
RUN echo "set -o vi" >> /etc/profile

ENTRYPOINT /bin/bash --login
