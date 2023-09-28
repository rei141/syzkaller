#!/bin/bash
set -eux
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

BASE_DIR="/home/ishii/nestedFuzz/linux-syzkaller_v6.5"
VMLINUX="$BASE_DIR/vmlinux"

# rawcoverファイルが存在するディレクトリのパス
COVERAGE_DIR="."

# 出力を保存するディレクトリのパス
OUTPUT_DIR="./out"

for file in $COVERAGE_DIR/rawcover.*; do
    # ファイル名から番号を抽出
    number=$(basename $file | cut -d'.' -f2)
    if [ ! -f $OUTPUT_DIR/coverage.$number ]; then
      # コマンドを実行し、出力を番号付きのファイルに保存
      $SCRIPT_DIR/baseline.sh -b $VMLINUX -c $file > $OUTPUT_DIR/coverage.$number
    fi
    echo $number
    grep "nested.c" $OUTPUT_DIR/coverage.$number | wc
done
