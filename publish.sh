#!/bin/bash

# 사용법 체크: 제목이 없으면 안내 출력
if [ -z "$1" ]; then
    echo "사용법: ./publish.sh \"글 제목\" \"글 본문 내용\""
    exit 1
fi

TITLE="$1"
CONTENT="$2"
DATE=$(date +"%Y-%m-%dT%H:%M:%S+09:00")
SLUG=$(date +"%Y%m%d%H%M%S")
FILENAME="content/posts/${SLUG}.md"

# 마크다운 글 파일 자동 생성
cat << POST > "$FILENAME"
---
title: "${TITLE}"
date: ${DATE}
draft: false
---

${CONTENT}
POST

echo " 새 글 파일 생성 완료: $FILENAME"

# GitHub에 자동 푸시
git add .
git commit -m "post: ${TITLE}"
git push origin main

echo " 배포 완료! 1~2분 뒤 Cloudflare Pages에 자동 반영됩니다."
