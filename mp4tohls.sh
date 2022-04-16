#!/bin/bash

# This script converts a video file to ts chunks and then to an hls playlist

# Check if the file exists.
if [ ! -f "$1" ]; then
  echo "File does not exist."
  exit 1
fi

# Array of video mimetypes
declare -a video_mimetypes=(
  "video/mp4"
  "video/x-m4v"
  "video/quicktime"
  "video/x-msvideo"
  "video/x-ms-wmv"
)

# Check if the file is a video file by checking the file header and the mimetype.
if [ "$(file --brief --mime-type "$1")" != "${video_mimetypes[0]}" ] \
  && [ "$(file --brief --mime-type "$1")" != "${video_mimetypes[1]}" ] \
  && [ "$(file --brief --mime-type "$1")" != "${video_mimetypes[2]}" ] \
  && [ "$(file --brief --mime-type "$1")" != "${video_mimetypes[3]}" ] \
  && [ "$(file --brief --mime-type "$1")" != "${video_mimetypes[4]}" ]; then
  echo "File is not a video file."
  exit 1
fi

# Get the full path folder of the file.
file_folder="$(dirname "$1")"

#Get the file extension.
file_extension="${1##*.}"

# Get the file name without extension.
file_name="$(basename "$1" ."$file_extension")"

echo "File name: $file_name"
echo "File extension: $file_extension"
echo "File folder: $file_folder"
#ffmpeg -i "$1" -c copy -map 0 -f segment -segment_time 10 -reset_timestamps 1 "$out_put%03d.ts"
# Get rid of the file extension.
out_put="$file_folder/$file_name"

# Resize the video to 360p ts chunks.
ffmpeg -i "$1" -c copy -map 0 -f segment -segment_time 10 -reset_timestamps 1 "$out_put%03d.ts"

