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
