#!/bin/bash

set -e

if [[ $EUID -ne 0 ]]; then
  echo "Vui lòng chạy script này với quyền root!"
  exit 1
fi

ROOTFS_DIR="./alpine-rootfs"
ARCH=$(uname -m)

case "$ARCH" in
"x86_64") ARCH="x86_64" ;;
"aarch64") ARCH="aarch64" ;;
*)
  echo "Kiến trúc $ARCH không được hỗ trợ!"
  exit 1
  ;;
esac

ROOTFS_URL="https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/$ARCH/alpine-minirootfs-3.18.4-$ARCH.tar.gz"

if [ -d "$ROOTFS_DIR" ]; then
  echo "Thư mục $ROOTFS_DIR đã tồn tại! Vui lòng xóa hoặc chọn thư mục khác."
  exit 1
fi

mkdir -p "$ROOTFS_DIR"
echo "Đang tải xuống rootfs..."
curl -L "$ROOTFS_URL" -o alpine-rootfs.tar.gz

echo "Giải nén rootfs..."
tar -xzf alpine-rootfs.tar.gz -C "$ROOTFS_DIR"

rm alpine-rootfs.tar.gz
echo "Đã cài đặt rootfs tại $ROOTFS_DIR."
echo "Sử dụng chroot để truy cập rootfs:"
echo "  sudo chroot $ROOTFS_DIR /bin/sh"
