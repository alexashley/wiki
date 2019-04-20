#!/usr/bin/env bash

git diff-index --quiet HEAD

if [[ $? -ne 0 ]]; then
      git commit -m "[skip ci] Build tiddlywiki"
      git push origin master
fi
