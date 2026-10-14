FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV NVIM_DOCKERFILE_SHELL=zsh
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/root/.nix-profile/bin:${PATH}"
ENV LUA_PATH=".luarocks/share/lua/5.1/?.lua;.luarocks/share/lua/5.1/?/init.lua;lua/?.lua;lua/?/init.lua;;"
ENV LUA_CPATH=".luarocks/lib/lua/5.1/?.so;;"

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        fd-find \
        file \
        git \
        gnupg \
        golang-go \
        gopls \
        imagemagick \
        libluajit-5.1-dev \
        locales \
        luajit \
        luarocks \
        nix-bin \
        nodejs \
        npm \
        procps \
        python3 \
        python3-pip \
        ripgrep \
        software-properties-common \
        unzip \
        wl-clipboard \
        xz-utils \
        zsh \
    && ln -s "$(command -v fdfind)" /usr/local/bin/fd \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

RUN add-apt-repository -y ppa:neovim-ppa/unstable \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg \
        | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com noble main" \
        > /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update && apt-get install -y --no-install-recommends \
        neovim \
        terraform \
        terraform-ls \
    && rm -rf /var/lib/apt/lists/*

RUN touch /.dockerenv \
    && NONINTERACTIVE=1 /bin/bash -c \
        "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    && brew install \
        lua-language-server \
        rust-analyzer

RUN mkdir -p /etc/nix \
    && printf 'build-users-group =\nexperimental-features = nix-command flakes\n' > /etc/nix/nix.conf \
    && nix profile install \
        nixpkgs#alejandra \
        nixpkgs#nixd \
        nixpkgs#rustfmt

RUN npm install -g --prefix /opt/ast-grep @ast-grep/cli \
    && ln -s /opt/ast-grep/bin/ast-grep /usr/local/bin/ast-grep \
    && npm install -g \
        @fsouza/prettierd \
        @johnnymorganz/stylua-bin \
        neovim \
        prettier \
        pyright \
        typescript@5 \
        typescript-language-server \
        vscode-langservers-extracted

RUN pip3 install --break-system-packages \
        black \
        isort

RUN luarocks --lua-version=5.1 install luacheck

RUN curl -fsSL https://github.com/arduino/arduino-language-server/releases/download/0.7.7/arduino-language-server_0.7.7_Linux_64bit.tar.gz \
        -o /tmp/arduino-ls.tar.gz \
    && tar -xzf /tmp/arduino-ls.tar.gz -C /usr/local/bin arduino-language-server \
    && rm /tmp/arduino-ls.tar.gz

WORKDIR /root/.config/nvim
COPY . /root/.config/nvim

RUN TERM=dumb nvim --headless "+Lazy! sync" +qa \
    ; test "$(ls /root/.local/share/nvim/lazy | wc -l)" -ge 30

ENTRYPOINT ${NVIM_DOCKERFILE_SHELL} -l
