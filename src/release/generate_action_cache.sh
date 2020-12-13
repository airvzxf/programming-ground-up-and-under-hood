#!/bin/bash -e

SOURCE=${HOME}/cache-linux
echo "# --------------------------------------------------------"
echo "# Where am I?"
pwd
echo "HOME: ${HOME}"
echo "SOURCE: ${SOURCE}"
ls -lha /
du -h -d 1 / 2> /dev/null || true
echo "# --------------------------------------------------------"
echo "# APT update"
apt update
echo "# --------------------------------------------------------"
echo "# Set up snapshot"
mkdir -p "${HOME}"/snapshots/
echo "# --------------------------------------------------------"
echo "# Install tools"
rm -f /var/lib/apt/lists/lock
apt install -y vim bash-completion
echo "# --------------------------------------------------------"
echo "# Take first snapshot"
find / \
  -type f,l \
  -not \( -path "/sys*" -prune \) \
  -not \( -path "/proc*" -prune \) \
  -not \( -path "/mnt*" -prune \) \
  -not \( -path "/dev*" -prune \) \
  -not \( -path "/run*" -prune \) \
  -not \( -path "/etc/mtab*" -prune \) \
  -not \( -path "/var/cache/apt/archives*" -prune \) \
  -not \( -path "/tmp*" -prune \) \
  -not \( -path "/var/tmp*" -prune \) \
  -not \( -path "/var/backups*" \) \
  -not \( -path "/boot*" -prune \) \
  -not \( -path "/vmlinuz*" -prune \) \
  > "${HOME}"/snapshots/snapshot_01.txt 2> /dev/null \
  || true
echo "# --------------------------------------------------------"
echo "# Install pandoc and dependencies"
apt install -y texlive-latex-extra wget
wget -q https://github.com/jgm/pandoc/releases/download/2.11.2/pandoc-2.11.2-1-amd64.deb
dpkg -i pandoc-2.11.2-1-amd64.deb
rm -f pandoc-2.11.2-1-amd64.deb
echo "# --------------------------------------------------------"
echo "# Take second snapshot"
find / \
  -type f,l \
  -not \( -path "/sys*" -prune \) \
  -not \( -path "/proc*" -prune \) \
  -not \( -path "/mnt*" -prune \) \
  -not \( -path "/dev*" -prune \) \
  -not \( -path "/run*" -prune \) \
  -not \( -path "/etc/mtab*" -prune \) \
  -not \( -path "/var/cache/apt/archives*" -prune \) \
  -not \( -path "/tmp*" -prune \) \
  -not \( -path "/var/tmp*" -prune \) \
  -not \( -path "/var/backups*" \) \
  -not \( -path "/boot*" -prune \) \
  -not \( -path "/vmlinuz*" -prune \) \
  > "${HOME}"/snapshots/snapshot_02.txt 2> /dev/null \
  || true
echo "# --------------------------------------------------------"
echo "# Filter new files"
diff -C 1 \
  --color=always \
  "${HOME}"/snapshots/snapshot_01.txt "${HOME}"/snapshots/snapshot_02.txt \
  | grep -E "^\+" \
  | sed -E s/..// \
    > "${HOME}"/snapshots/snapshot_new_files.txt
wc < "${HOME}"/snapshots/snapshot_new_files.txt -l
ls -lha "${HOME}"/snapshots/
echo "# --------------------------------------------------------"
echo "# Make cache directory"
rm -fR "${SOURCE}"
mkdir -p "${SOURCE}"
while IFS= read -r LINE; do
  cp -a --parent "${LINE}" "${SOURCE}"
done < "${HOME}"/snapshots/snapshot_new_files.txt
ls -lha "${SOURCE}"
echo ""
du -sh "${SOURCE}" || true
echo "# --------------------------------------------------------"
