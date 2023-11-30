#!/bin/bash

MSG="$1"
if [ -z "$MSG" ]; then
    read -p "Commit message: " MSG
fi

git add .
git commit -m "hs/try-haskell $MSG"
git push
