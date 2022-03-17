FROM debian:bullseye-slim

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       latexmk \
       lmodern \
       make \
       texlive \
       texlive-fonts-extra \
       texlive-fonts-extra-links \
       texlive-lang-chinese \
       texlive-lang-cjk \
       texlive-xetex \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
