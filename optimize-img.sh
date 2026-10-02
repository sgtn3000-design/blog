#!/bin/bash
# 사용법: ./optimize-img.sh [입력_이미지_경로_또는_URL]
INPUT="$1"
if [ -z "$INPUT" ]; then exit 1; fi

mkdir -p static/images
IMG_ID=$(date +"%Y%m%d%H%M%S")_$RANDOM
TARGET_NAME="${IMG_ID}.webp"
OUTPUT_PATH="static/images/${TARGET_NAME}"
TEMP_SRC="/tmp/img_${IMG_ID}"

if [[ "$INPUT" =~ ^https?:// ]]; then
    curl -sL "$INPUT" -o "$TEMP_SRC"
else
    cp "$INPUT" "$TEMP_SRC"
fi

convert "$TEMP_SRC" -resize "1200x>" -quality 80 "$OUTPUT_PATH"
rm -f "$TEMP_SRC"

# 최종 블로그 상대 경로만 반환
echo "/images/${TARGET_NAME}"
