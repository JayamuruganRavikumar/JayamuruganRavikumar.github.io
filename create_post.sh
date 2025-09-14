#!/bin/zsh

# Script to create a new file for posts.

# Usage ./create_post.sh "Title"

if [ $# -eq 0 ]; then
  echo "No Title provided"
  exit 1
fi

title="$1"

filename_title=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g' | sed 's/[^a-z0-9-]//g')

current_date="$(date +"%Y-%m-%d")" # Jekyll uses y-m-d format
current_time="$(date +"%H:%M:%S %z")"

filename="${current_date}-${filename_title}.md"
file_path="_posts/${filename}"

if [ -f "$file_path" ]; then
  echo "File already exists"
  exit 1
fi

cat > "$file_path" << EOF
---
title: $title
author: jay
date: "${current_date} ${current_time}"
categories: [Blogging, Tutorial]
tags: [writing]
render_with_liquid: false
---

## Introduction

EOF

echo "create new post"

