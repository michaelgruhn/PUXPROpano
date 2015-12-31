#!/usr/bin/python2
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

#
# super simple poc python script converting from the sp360 fisheye to
# a rectangular file thingy ...not sure the transformation is correct
# it simply maps the polar coordinates in the input image to the
# rectangular coordinates of the output image
#
# NO INTERPOLATION IS DONE!
# NO OPTIMIZATION IS DONE!


import sys
import math

from PIL import Image

inim = Image.open(sys.argv[1])

h = inim.size[0] / 2
w = 3*h

outim = Image.new("RGB", (w,h*2), "black")

for x in xrange(0,w):
	for y in xrange(0,h):
		r = y
		p = 2*math.pi*x/w
		ix = h - r * math.cos(p)
		iy = h + r * math.sin(p)
		#print (ix, iy)
		outim.putpixel((x,y),inim.getpixel((ix,iy)))

outim.save(sys.argv[2])

