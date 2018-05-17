#!/bin/bash

for filename in *.m4a; do
  REC=${filename%.*}
  ffmpeg -hide_banner -i "${REC}.m4a" -c:a copy -filter_complex color=white -shortest -preset ultrafast -r 5 "${REC}.mp4"
done
