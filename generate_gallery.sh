#!/bin/bash
echo "<html><head><title>Panorama Pictures converted with PUXPROpano</title></head><body>"
for file in "$@"; do
	thumbname=$(basename -s _pano.jpg ${file})_thumb.jpg
	convert -define jpeg:size=512x256 ${file} -thumbnail '256x128>' -quality 80 ${thumbname}
	echo "<a href=\"pannellum.htm?panorama=${file}\"><img src=\"${thumbname}\"></a>"
done
echo "</body></html>"
