#! /bin/bash

STREAMS_DIR=/mnt/streamfs/streams
STREAM_QUALITIES="16 32 64 128 192"

mkdir -p ${STREAMS_DIR}
cd ${STREAMS_DIR}

for QUALITY in ${STREAM_QUALITIES}
do
  mkdir -p ${STREAMS_DIR}/${QUALITY}k
done

ffmpeg -loglevel quiet -i "https://radio.plaza.one/mp3" \
       -c:a aac -b:a 16k -f hls -hls_time 10 -hls_list_size 10 -hls_flags delete_segments -hls_base_url "16k/" -hls_segment_filename "16k/%03d.ts" 16k.m3u8 \
       -c:a aac -b:a 32k -f hls -hls_time 10 -hls_list_size 10 -hls_flags delete_segments -hls_base_url "32k/" -hls_segment_filename "32k/%03d.ts" 32k.m3u8 \
       -c:a aac -b:a 64k -f hls -hls_time 10 -hls_list_size 10 -hls_flags delete_segments -hls_base_url "64k/" -hls_segment_filename "64k/%03d.ts" 64k.m3u8 \
       -c:a aac -b:a 128k -f hls -hls_time 10 -hls_list_size 10 -hls_flags delete_segments -hls_base_url "128k/" -hls_segment_filename "128k/%03d.ts" 128k.m3u8 \
       -c:a aac -b:a 192k -f hls -hls_time 10 -hls_list_size 10 -hls_flags delete_segments -hls_base_url "192k/" -hls_segment_filename "192k/%03d.ts" 192k.m3u8 &

ffmpeg_pid=$!

echo '#EXTM3U' > playlist.m3u8

pwd && ls -la

REVERSED=`tac <( echo ${STREAM_QUALITIES} | tr ' ' '\n') | tr '\n' ' '`
echo "REVERSED: ${REVERSED}"

for QUALITY in ${REVERSED}
do
  echo "Checking for ${QUALITY}k.m3u8"
  while [ -s ${QUALITY}k.m3u8 ]; do echo -n '.'; sleep 1; done
  echo
  echo "Echoing stream info"
  echo -e "#EXT-X-STREAM-INF:BANDWITH=${QUALITY}000\n${QUALITY}k.m3u8" >> playlist.m3u8
done

service nginx start

wait $ffmpeg_pid
