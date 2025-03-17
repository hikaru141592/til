#!/bin/bash

echo "til_search.sh 実行開始"

if [ $# -eq 0 ]; then
  echo "使用方法: til_search.sh タグ1 [タグ2 ...]"
  exit 1
fi

SEARCH_DIR="."
FILES=$(grep -r --include="*.md" -l "$1" "$SEARCH_DIR/")

for file in $FILES; do
  MATCH=true
  for tag in "$@"; do
    if ! grep -q "$tag" "$file"; then
      MATCH=false
      break
    fi
  done

  if $MATCH; then
    # ファイル名の表示
    echo -e "\n=== ファイル: $file ==="

    # 学習内容の表示
    awk '/^## 学習内容/,/---/' "$file" | while read line; do
      # タイトルやタグを強調する
      if [[ "$line" =~ "タイトル" ]]; then
        echo -e "\033[1;32m$line\033[0m"  # タイトルを緑色で強調
      elif [[ "$line" =~ "タグ" ]]; then
        echo -e "\033[1;33m$line\033[0m"  # タグを黄色で強調
      else
        echo "$line"
      fi
    done

    # 学習内容の間に空行を追加
    echo ""

  fi
done
