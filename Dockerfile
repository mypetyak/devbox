FROM debian:jessie
MAINTAINER Christopher Bunn <bunn@uber.com>

RUN apt-get update
RUN apt-get install -y \
    build-essential \
    curl \
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
    tar \
    tcpdump \
    vim \
    wget \
    zsh

RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
RUN rm get-pip.py

# Set locale info for tmux's (and others) benefit
RUN echo 'en_US UTF-8' > /etc/locale.gen
RUN locale-gen

RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

RUN mkdir -p /root/.oh-my-zsh/functions
RUN curl https://raw.githubusercontent.com/sindresorhus/pure/master/pure.zsh -o /root/.oh-my-zsh/functions/prompt_pure_setup

RUN curl https://raw.githubusercontent.com/sindresorhus/pure/master/async.zsh -o /root/.oh-my-zsh/functions/async

RUN curl https://raw.githubusercontent.com/mypetyak/dotfiles/master/.zshrc -o /root/.zshrc

RUN curl https://raw.githubusercontent.com/mypetyak/dotfiles/master/.vimrc -o /root/.vimrc

RUN git clone https://github.com/gmarik/Vundle.vim.git /root/.vim/bundle/Vundle.vim
RUN vim +PluginInstall +qall

RUN curl -O http://ftp3.nrc.ca/debian/pool/main/t/tmux/tmux_2.2.orig.tar.gz && tar -xvf tmux_2.2.orig.tar.gz && cd tmux-2.2 && ./configure && make && make install

RUN curl https://raw.githubusercontent.com/mypetyak/dotfiles/master/.tmux.conf -o /root/.tmux.conf

ENTRYPOINT /bin/zsh
