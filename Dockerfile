FROM debian:stretch
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
    entr \
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
    ngrep \
    pkg-config \
    python \
    python-setuptools \
    silversearcher-ag \
    software-properties-common \
    strace \
    sudo \
    sysstat \
    tar \
    tmux \
    tcpdump \
    unzip \
    vim \
    wget

# Set locale info for tmux's (and others) benefit
RUN echo 'en_US UTF-8' > /etc/locale.gen
RUN locale-gen

# install pip
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
RUN rm get-pip.py

# install golang
RUN wget https://storage.googleapis.com/golang/go1.9.2.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.9.2.linux-amd64.tar.gz
RUN rm go1.9.2.linux-amd64.tar.gz
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
RUN PATH=$PATH:/usr/local/go/bin GOPATH=/root/gocode go get github.com/nsf/gocode
RUN PATH=$PATH:/usr/local/go/bin GOPATH=/root/gocode go get github.com/alecthomas/gometalinter
RUN PATH=$PATH:/usr/local/go/bin GOPATH=/root/gocode go get golang.org/x/tools/cmd/goimports
RUN PATH=$PATH:/usr/local/go/bin GOPATH=/root/gocode go get golang.org/x/tools/cmd/guru
RUN PATH=$PATH:/usr/local/go/bin GOPATH=/root/gocode go get golang.org/x/tools/cmd/gorename
RUN PATH=$PATH:/usr/local/go/bin GOPATH=/root/gocode go get github.com/golang/lint/golint
RUN PATH=$PATH:/usr/local/go/bin GOPATH=/root/gocode go get github.com/rogpeppe/godef
RUN PATH=$PATH:/usr/local/go/bin GOPATH=/root/gocode go get github.com/kisielk/errcheck
RUN PATH=$PATH:/usr/local/go/bin GOPATH=/root/gocode go get github.com/jstemmer/gotags
RUN PATH=$PATH:/usr/local/go/bin GOPATH=/root/gocode go get github.com/klauspost/asmfmt/cmd/asmfmt
RUN PATH=$PATH:/usr/local/go/bin GOPATH=/root/gocode go get github.com/fatih/motion
RUN PATH=$PATH:/usr/local/go/bin GOPATH=/root/gocode go get github.com/fatih/gomodifytags
RUN PATH=$PATH:/usr/local/go/bin GOPATH=/root/gocode go get github.com/zmb3/gogetdoc
RUN PATH=$PATH:/usr/local/go/bin GOPATH=/root/gocode go get github.com/josharian/impl
RUN PATH=$PATH:/usr/local/go/bin GOPATH=/root/gocode go get github.com/dominikh/go-tools/cmd/keyify

# install tmux doftile
RUN wget -O /etc/tmux.conf https://raw.githubusercontent.com/mypetyak/dotfiles/bunn/devbox/.tmux.conf

# install fasd
RUN curl https://raw.githubusercontent.com/clvv/fasd/master/fasd -o /usr/bin/fasd
RUN chmod +x /usr/bin/fasd

# set vi mode
RUN echo "set -o vi" >> /etc/bash.bashrc

ENTRYPOINT /usr/bin/tmux
