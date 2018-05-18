### Originals

Original audio files for Dharma teaching and meditation instructions at Wat Kow Tham.

* [10-20 April 2018 by Dr.Marut Damchaom](https://bintray.com/wat-kow-tham/lectures/dharma/20180410-20180420#files)

### How to encode and upload to YouTube

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

**generate 1 hour white color video**

We need to create video stream, because YouTube refuses to accept files with
only audio inside. First we need to learn how to create blank video.

The command below uses `color` filter to produce video stream with white
background. `-t` parameter limits time of the resulting video to 1 hour.
Last parameter is filename of resulting file `white.webm` - for `ffmpeg` it
is **output** #0.

```
$ ffmpeg -hide_banner -t 3600 -filter_complex color=white white.webm
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
Now `white.webm` contains 1 hour of blank white video. `-filter_complex`
param is used to specify **filters** for video processing. `.webm` format
for output was detected automatically, and then `ffmpeg` automatically
mapped output of `color filter` to output stream `#0:0`.

**create combined audio+video file from separate input streams**

We now create single `.mp4` video+audio file from separate `.m4a` stream and
separate blank white video stream.

The command below tells `ffmpeg` to copy default `input audio stream` as is
(`-codec:a copy` or `-c:a copy`), then produce video stream using filter
(`-filter_complex color=white`) and stop encoding when one or another input
stream ends (`-shortest`).

```
$ ffmpeg -hide_banner -i 20180412_002.m4a -codec:a copy -filter_complex color=white -shortest whiteaudio.mp4

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
Stream mapping:
  color -> Stream #0:0 (libx264)
  Stream #0:0 -> #0:1 (copy)
...
Output #0, mp4, to 'whiteaudio.mp4':
  Metadata:
    major_brand     : mp42
    minor_version   : 0
    compatible_brands: isommp42
    com.android.version: 6.0
    encoder         : Lavf58.12.100
    Stream #0:0: Video: h264 (libx264) (avc1 / 0x31637661), yuv420p, 320x240 [SAR 1:1 DAR 4:3], q=-1--1, 25 fps, 12800 tbn, 25 tbc (default)
    Metadata:
      encoder         : Lavc58.18.100 libx264
    Side data:
      cpb: bitrate max/min/avg: 0/0/0 buffer size: 0 vbv_delay: -1
    Stream #0:1(eng): Audio: aac (LC) (mp4a / 0x6134706D), 48000 Hz, stereo, fltp, 128 kb/s (default)
    Metadata:
      creation_time   : 2018-04-12T08:39:53.000000Z
      handler_name    : SoundHandle
frame=  484 fps=0.0 q=28.0 size=     256kB time=00:00:17.24 bitrate= 121.7kbits/s spee
frame=  974 fps=972 q=28.0 size=     512kB time=00:00:36.84 bitrate= 113.9kbits/s spee
frame= 1913 fps=1273 q=28.0 size=    1024kB time=00:01:14.40 bitrate= 112.8kbits/s spee
frame= 2838 fps=1417 q=28.0 size=    1536kB time=00:01:51.40 bitrate= 113.0kbits/s spee
...
frame=68597 fps=2077 q=28.0 size=   43776kB time=00:45:41.76 bitrate= 130.8kbits/s spee
```
`fps=2077` in the last line means that `ffmpeg` could encode 2077 "frames per second",
and `25 fps` in output stream description means that our blank white video plays at 25
frames per second.

**speedup video encoding**

For encoding to `.mp4` FFmpeg provides [several presets](https://trac.ffmpeg.org/wiki/Encode/H.264#Preset).
Blank white video doesn't need any quality controls, so we can just use the fastest
`-preset ultrafast` and drop frames per second in output video (frame rate) to 5 (`-r 5`).

    $ REC="20180412_002"; time ffmpeg -hide_banner -i "${REC}.m4a" -c:a copy -filter_complex color=white -shortest -preset ultrafast -r 5 "${REC}.mp4"

This command uses shell variable to reuse filename for input and output. Using framerate
of 5 frames per second makes `vlc` complain while playing, but should be okay
[for YouTube](https://support.google.com/youtube/answer/1722171?hl=en).

**normalize audio and convert to .webm**

Let's apply audio filter for dynamic audio normalization `-af dynaudform`. And
because audio processing requires reencoding, let's save the result into open
`.webm` format that is unencumbered by patents.

    $ REC="20180412_002"; time ffmpeg -hide_banner -i "${REC}.m4a" -af dynaudnorm -filter_complex color=white -deadline realtime -shortest -r 5 "${REC}.webm"

`-deadline realtime` is an option to speedup
[VP9 encoding](https://trac.ffmpeg.org/wiki/Encode/VP9). `ffmpeg` chooses
Opus audio codec and VP9 video codec for `.webm` format automatically.

