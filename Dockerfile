FROM --platform=linux/x86-64 ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y upgrade && apt-get -y install \
    unzip \
    zip \
    make \
    gcc \
    m4 \
    rlwrap \
    clang \
    curl \
    lldb \
    patch \
    git \
    bzip2 \
    wget \
    # for VS Code live sharing
    libicu66 \
    # for dune build --watch
    inotify-tools 


# RUN wget -O ~/vsls-reqs https://aka.ms/vsls-linux-prereq-script && chmod +x ~/vsls-reqs && ~/vsls-reqs

ENV OPAMYES=true OPAMROOTISOK=true
RUN curl -sL https://github.com/ocaml/opam/releases/download/2.1.3/opam-2.1.3-x86_64-linux -o opam \
    && install opam /usr/local/bin/opam \
    && opam init --disable-sandboxing -a -y --bare \
    && opam update

RUN opam switch create 4.14.0
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install these dependencies early to increase intermediate image reuse
COPY ./tiger.opam* .

RUN opam install .  --deps-only --locked && \
    opam user-setup install && \
    eval $(opam env)
