#!/bin/bash

for filename in *.m4a; do
  REC=${filename%.*}
  # .mp4 fast encoding setting with audio copy and without normalization
  #ffmpeg -hide_banner -i "${REC}.m4a" -c:a copy -filter_complex color=white -shortest -preset ultrafast -r 5 "${REC}.mp4"

  # .webm fast encoding with autio normalization
  ffmpeg -hide_banner -i "${REC}.m4a" -af dynaudnorm -filter_complex color=white -deadline realtime -shortest -r 5 "${REC}.webm"
done
