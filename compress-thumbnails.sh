#!/bin/bash
#Compress PNG thumbnails on Linux operating systems
#Compatible with Freedesktop.org (GTK) and KDE thumbnail standards

log_file="$HOME/.cache/thumbnails/delete_used_thumbnail.log"
compressed=0

#Find all PNG files in the thumbnail cache
while IFS= read -r thumbnail; do
    #Skip if already marked
    if grep -aq "CompressedWith=pngquant" "$thumbnail"; then
        continue
    fi
	
    tmp="${thumbnail}.tmp"

    if pngquant --force --output "$tmp" --quality 50 "$thumbnail"; then
		#Appends string to the end of the file which is ignored by PNG decoders
        echo "CompressedWith=pngquant" >> "$tmp"
        mv "$tmp" "$thumbnail"
        compressed=$((compressed + 1))
    fi
done < <(find /home/user/.cache/thumbnails -type f -name '*.png')

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Compressed $compressed thumbnails." | tee -a "$log_file"
