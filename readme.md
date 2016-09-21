#nimBMP
BMP Encoder and Decoder written in Nim

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


##Basic Usage

```nimrod
import nimBMP

let bmp24 = loadBMP24("image24.bmp") #load bmp as RGB 24 bit
let bmp32 = loadBMP32("image32.bmp") #load bmp as RGBX 32 bit


```

the returned object from loadBMP24 or loadBMP32 have fields:
  - bmp.width  -> the width of the decoded image
  - bmp.height -> the height of the decoded image
  - bmp.data   -> contigous pixels stored in Nim string 
     * loadBMP24 will produce r1,g1,b1,r2,g2,b2,...,rn,gn,bn
     * loadBMP32 will produce r1,g1,b1,x1,...,rn,gn,bn,xn
     
     
##Create BMP from raw pixels

```nimrod
import nimBMP

saveBMP32("image32.bmp", rgbx_pixels, width, height)
saveBMP24("image24.bmp", rgb_pixels, width, height)

```

the internal algorithm of saveBMP will choose the best target format after it analyze the image's content.
