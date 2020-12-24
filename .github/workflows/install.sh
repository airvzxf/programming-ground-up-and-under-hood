#!/bin/bash -e

echo "# --------------------------------------------------------"
echo "# APT update"
sudo apt update
echo "# --------------------------------------------------------"
echo "# Install pandoc and dependencies"
sudo rm -f /var/lib/apt/lists/lock
sudo apt install -y texlive-latex-extra wget
wget -q https://github.com/jgm/pandoc/releases/download/2.11.2/pandoc-2.11.2-1-amd64.deb
sudo dpkg -i pandoc-2.11.2-1-amd64.deb
rm -f pandoc-2.11.2-1-amd64.deb
echo "# --------------------------------------------------------"
