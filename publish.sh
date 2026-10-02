#!/bin/bash

if [ -z "$1" ]; then
    echo "사용법: ./publish.sh \"제목\" \"본문 내용\" [카테고리] [태그1,태그2] [이미지_파일_또는_URL]"
    exit 1
fi

TITLE="$1"
CONTENT="$2"
CATEGORY="${3:-일반}"
TAGS="${4:-Note}"
INPUT_IMAGE="$5"
DATE=$(date +"%Y-%m-%dT%H:%M:%S+09:00")
SLUG=$(date +"%Y%m%d%H%M%S")
FILENAME="content/posts/${SLUG}.md"
IMAGE_FINAL_PATH=""

# 이미지 압축 및 WebP 변환 처리
if [ -n "$INPUT_IMAGE" ]; then
    mkdir -p static/images
    TARGET_IMG_NAME="${SLUG}.webp"
    OUTPUT_PATH="static/images/${TARGET_IMG_NAME}"
    TEMP_SRC="/tmp/temp_${SLUG}_raw"

    echo "🖼️ 이미지 최적화 처리 시작..."

    # 웹 URL인 경우 다운로드, 로컬 파일인 경우 복사
    if [[ "$INPUT_IMAGE" =~ ^https?:// ]]; then
        curl -sL "$INPUT_IMAGE" -o "$TEMP_SRC"
    else
        cp "$INPUT_IMAGE" "$TEMP_SRC"
    fi

    # 가로 최대 1200px 리사이징 및 WebP (품질 80%) 압축 변환
    convert "$TEMP_SRC" -resize "1200x>" -quality 80 "$OUTPUT_PATH"
    rm -f "$TEMP_SRC"

    # 용량 확인 출력
    FILE_SIZE=$(du -h "$OUTPUT_PATH" | cut -f1)
    echo "✅ 이미지 압축 완료: /images/${TARGET_IMG_NAME} (용량: ${FILE_SIZE})"
    IMAGE_FINAL_PATH="/images/${TARGET_IMG_NAME}"
fi

FORMATTED_TAGS=$(echo "$TAGS" | sed 's/,/", "/g')

COVER_BLOCK=""
if [ -n "$IMAGE_FINAL_PATH" ]; then
COVER_BLOCK="cover:
    image: \"${IMAGE_FINAL_PATH}\"
    alt: \"${TITLE}\"
    relative: false"
fi

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

echo "📝 새 글 생성 완료: $FILENAME"

git add .
git commit -m "post: ${TITLE}"
git push origin main

echo "🚀 배포 완료! 1~2분 후 사이트에 반영됩니다."
