# nimBMP
BMP Encoder and Decoder written in Nim

[![Build Status (Travis)](https://img.shields.io/travis/jangko/nimBMP/master.svg?label=Linux%20/%20macOS "Linux/macOS build status (Travis)")](https://travis-ci.org/jangko/nimBMP)
[![Windows build status (Appveyor)](https://img.shields.io/appveyor/ci/jangko/nimBMP/master.svg?label=Windows "Windows build status (Appveyor)")](https://ci.appveyor.com/project/jangko/nimBMP)
![nimble](https://img.shields.io/badge/available%20on-nimble-yellow.svg?style=flat-square)
![license](https://img.shields.io/github/license/citycide/cascade.svg?style=flat-square)

supported standard color mode:

  - 1 bit
  - 4 bit uncompressed and compressed
  - 8 bit uncompressed and compressed
  - 16 bit with color mask
  - 24 bit
  - 32 bit with color mask

both inverted(top-down) and non inverted mode supported

Supported color conversions:

- 32/24bit to 1, 4, 8, 24 bit
- automatic palette generation


## Basic Usage

```nimrod
import nimBMP

let bmp24 = loadBMP24("image24.bmp") #load bmp as RGB 24 bit
let bmp32 = loadBMP32("image32.bmp") #load bmp as RGBX 32 bit

# the default container is string,
# if you want the output container is seq[uint8],
# you can specify it as second param
let bmp24seq = loadBMP24("image24.bmp", seq[uint8]) #load bmp as RGB 24 bit into seq[uint8]
let bmp32seq = loadBMP32("image32.bmp", seq[uint8]) #load bmp as RGBX 32 bit into seq[uint8]

```

the returned object from loadBMP24 or loadBMP32 have fields:
  - bmp.width  -> the width of the decoded image
  - bmp.height -> the height of the decoded image
  - bmp.data   -> contigous pixels stored in Nim string
     * loadBMP24 will produce r1,g1,b1,r2,g2,b2,...,rn,gn,bn
     * loadBMP32 will produce r1,g1,b1,x1,...,rn,gn,bn,xn


## Create BMP from raw pixels

```nimrod
import nimBMP

saveBMP32("image32.bmp", rgbx_pixels, width, height)
saveBMP24("image24.bmp", rgb_pixels, width, height)
saveBMP8("image8.bmp", gray_pixels, width, height)
```

The second param to `saveBMPxx` is raw input pixel.
The input pixels can be a sequence of bytes in string container or seq[uint8] container

The internal algorithm of saveBMP will choose the best target format after it analyze the image's content.

## Installation via nimble
> nimble install nimBMP
