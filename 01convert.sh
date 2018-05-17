#!/bin/bash

for filename in *.m4a; do
  echo ${filename}
done

#REC="20180412_002"; time ffmpeg -hide_banner -i "${REC}.m4a" -c:a copy -filter_complex color=white -shortest -preset ultrafast -r 5 "${REC}.mp4"
