#!/usr/bin/bash

for typ in "raw" "normal" "uncurried"; do
  node --max_old_space_size=4096 --gc_interval=100 bench/main.js $typ
done
