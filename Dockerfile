FROM alpinelab/ruby-dev

RUN apt-get update \
 && apt-get install --assume-yes --no-install-recommends --no-install-suggests \
      tmux \
 && rm -rf /var/lib/apt/lists/*
