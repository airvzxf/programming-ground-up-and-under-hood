# Dockerfile for "Programming from the Ground Up"
# Use Ubuntu to ensure compatibility with 32-bit assembly examples (glibc)
FROM ubuntu:22.04

# Avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
# - pandoc, texlive-*: To generate the book (PDF/EPUB)
# - build-essential, gcc-multilib: To compile 32-bit assembly
# - zip, git: Auxiliary tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    pandoc \
    texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-latex-recommended \
    lmodern \
    build-essential \
    gcc-multilib \
    zip \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Working directory
WORKDIR /data

# Entry point
ENTRYPOINT ["/usr/bin/env", "bash"]