#!/bin/bash
#
# Copyright (c) 2015 Michael Gruhn
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#   - Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#   - Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in
#     the documentation and/or other materials provided with the
#     distribution.
#   - Neither the name PUXPROpano nor the names of its contributors may be
#     used to endorse or promote products derived from this software
#     without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# 
# PUXPROpano is not affiliated with Kodak.
# 
# Kodak, PIXPRO and maybe also SP360 are likely trademarks of Kodak.
# 



# ref: crop_values_25498235
# NOTE: these values may be different for your Kodak PIXPRO SP360 camera!
# available pixels when picture taken lens up (distance from raw PIXPRO SP360
# output to the black frame surrounding the raw image)
GOOD_PIXELS=950 # if black round corners appear _slightly_ at the bottom of the
                # panorama output this value is set correctly

if [ $# -ne 2 ]; then
	echo "usage: ${0} <input image> <output without jpg extension>"
	echo ""
	echo "Requires:"
	echo "    exiftool"
	echo "    nona, enblend  (hugin)"
	echo "    bash, sed, rm"
	echo "    convert (imagemagick)"
	exit 1
fi

orientation=$(exiftool -Orientation ${1} | sed 's/Orientation[ ]*: \(.*\)/\1/')

case $orientation in
	"Horizontal (normal)") orientation="up" ;;
	"Rotate 270 CW") orientation="side" ;;
	"Rotate 90 CW") orientation="side" ;;
	"Rotate 180") orientation="side" ;;
	*)
	orientation="up"
	echo "WARNING: no orientation EXIF data found! Are you sure this is an image from a Kodak PIXPRO SP360?"
	;;
esac

nona -z LZW  -r ldr -m TIFF_m -o ${2} -i 0 ${orientation}.pto ${1}
if [ "${orientation}" == "up" ]; then
	convert ${2}0000.tif -background black -fill black -draw "rectangle 0,${GOOD_PIXELS} 3000,1500" -extent 3000x1500 -normalize -quality 90 ${2}.jpg
else
#	CROP_LEFT=$((GOOD_PIXELS/2))
#	CROP_RIGHT=$((3000-CROP_LEFT))
#	convert ${2}0000.tif -background black -fill black -draw "rectangle 0,0 ${CROP_LEFT},1500 rectangle ${CROP_RIGHT},0 3000,1500" -extent 3000x1500 -normalize -quality 90 ${2}.jpg
	convert ${2}0000.tif -background black -extent 3000x1500 -normalize -quality 90 ${2}.jpg
fi
#enblend --compression=100 -w -f3000x1500 -o ${2}.jpg -- ${2}0000.tif
rm ${2}0000.tif

