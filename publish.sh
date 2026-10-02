#!/bin/bash

# 사용법 체크
if [ -z "$1" ]; then
    echo "사용법: ./publish.sh \"제목\" \"본문 내용\" [카테고리] [태그1,태그2]"
    exit 1
fi

TITLE="$1"
CONTENT="$2"
CATEGORY="${3:-Note}"
TAGS="${4:-General}"
DATE=$(date +"%Y-%m-%dT%H:%M:%S+09:00")
SLUG=$(date +"%Y%m%d%H%M%S")
FILENAME="content/posts/${SLUG}.md"

# 태그 배열 포맷팅 (쉼표 구분 -> 따옴표 배열)
FORMATTED_TAGS=$(echo "$TAGS" | sed 's/,/", "/g')

cat << POST > "$FILENAME"
---
title: "${TITLE}"
date: ${DATE}
categories: ["${CATEGORY}"]
tags: ["${FORMATTED_TAGS}"]
draft: false
---

${CONTENT}
POST

echo " 새 글 생성 완료: $FILENAME (카테고리: $CATEGORY / 태그: $TAGS)"

git add .
git commit -m "update site config & post: ${TITLE}"
git push origin main

echo " 배포 완료! 1~2분 후 반영됩니다."
