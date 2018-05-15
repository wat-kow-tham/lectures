Instructions how to record, process and upload audio lectures
for people to study, based on
https://github.com/wat-kow-tham/checklist/issues/1

Current workflow:

    .m4a (IPhone) --> .mp4 (ffmpeg) --> YouTube

Enhanced workflow:

    .m4a (IPhone) --> normalize (ffmpeg) --> .opus (ffmpeg) --> .webm (ffmpeg) --> YouTube

#### FFmpeg tutorial

The essential information you need to know about FFmpeg:

* it consumes videos and audios (**inputs**)
* it produces videos, audios, text files (**outputs**)
* most video files contain multiple **streams**
  * usually there is at least one audio stream and one video stream
  * the first stream of each type is used by default

**running**

    ffmpeg -hide_banner
    
By default `ffmpeg` produces somewhat confusing output, so `-hide_banner`
helps it to keep straight to the point.

**get information about audio/video file**
```
$ ffmpeg -hide_banner -i 20180412_002.m4a
Input #0, mov,mp4,m4a,3gp,3g2,mj2, from '20180412_002.m4a':
  Metadata:
    major_brand     : mp42
    minor_version   : 0
    compatible_brands: isommp42
    creation_time   : 2018-04-12T08:39:53.000000Z
    com.android.version: 6.0
  Duration: 01:09:38.81, start: 0.000000, bitrate: 130 kb/s
    Stream #0:0(eng): Audio: aac (LC) (mp4a / 0x6134706D), 48000 Hz, stereo, fltp, 128 kb/s (default)
    Metadata:
      creation_time   : 2018-04-12T08:39:53.000000Z
      handler_name    : SoundHandle
```
Here we specify `.m4a` audio file as input to `ffmpeg`, and then
`ffmpeg` reports that there is one input `#0` with one stream `#0:0`,
which is audio with some characteristics.

**generate endless white color video**
We need to create video stream, because YouTube refuses to accept files with only
audio inside. First we need to learn how to create blank video. Press **q** to stop.
```
$ ffmpeg -filter_complex color=white white.webm
Stream mapping:
  color -> Stream #0:0 (libvpx-vp9)
Press [q] to stop, [?] for help
[libvpx-vp9 @ 0x55a15c5de480] v1.7.0
Output #0, webm, to 'white.webm':
  Metadata:
    encoder         : Lavf58.12.100
    Stream #0:0: Video: vp9 (libvpx-vp9), yuv420p, 320x240 [SAR 1:1 DAR 4:3], q=-1--1, 200 kb/s, 25 fps, 1k tbn, 25 tbc (default)
    Metadata:
      encoder         : Lavc58.18.100 libvpx-vp9
    Side data:
      cpb: bitrate max/min/avg: 0/0/0 buffer size: 0 vbv_delay: -1
frame=   82 fps=0.0 q=0.0 size=       1kB time=00:00:02.28 bitrate=   2.2kbits/s spee
frame=  139 fps=138 q=0.0 size=       1kB time=00:00:04.56 bitrate=   1.1kbits/s spee
frame=  217 fps=144 q=0.0 size=       4kB time=00:00:07.68 bitrate=   3.8kbits/s spee
frame=  292 fps=145 q=0.0 size=       7kB time=00:00:10.68 bitrate=   5.0kbits/s spee  
```
Now `white.webm` contains blank white video. The `-filter_complex` just tells
`ffmpeg` to use **filters**. We used `.webm` format for output and `ffmpeg`
automatically mapped output of `color filter` to output stream `#0:0`.
