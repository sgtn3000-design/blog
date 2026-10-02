#!/bin/bash

# 사용법 체크
if [ -z "$1" ]; then
    echo "사용법: ./publish.sh \"제목\" \"본문 내용\" [카테고리] [태그1,태그2] [대표이미지_URL_또는_경로]"
    exit 1
fi

TITLE="$1"
CONTENT="$2"
CATEGORY="${3:-일반}"
TAGS="${4:-Note}"
IMAGE_URL="$5"
DATE=$(date +"%Y-%m-%dT%H:%M:%S+09:00")
SLUG=$(date +"%Y%m%d%H%M%S")
FILENAME="content/posts/${SLUG}.md"

# 태그 포맷팅
FORMATTED_TAGS=$(echo "$TAGS" | sed 's/,/", "/g')

# 커버 이미지 설정 블록 생성
COVER_BLOCK=""
if [ -n "$IMAGE_URL" ]; then
COVER_BLOCK="cover:
    image: \"${IMAGE_URL}\"
    alt: \"${TITLE}\"
    relative: false"
fi

# 마크다운 글 파일 생성
cat << POST > "$FILENAME"
---
title: "${TITLE}"
date: ${DATE}
categories: ["${CATEGORY}"]
tags: ["${FORMATTED_TAGS}"]
draft: false
${COVER_BLOCK}
---

${CONTENT}
POST

echo " 새 글 생성 완료: $FILENAME"
if [ -n "$IMAGE_URL" ]; then
    echo " 커버 이미지 연결: $IMAGE_URL"
fi

git add .
git commit -m "post: ${TITLE}"
git push origin main

echo " 배포 완료! 1~2분 후 사이트에 반영됩니다."
