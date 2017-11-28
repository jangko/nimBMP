import nimBMP, streams, strutils, os

type
  Image = object
    data: string
    width, height: int
    bitsPerPixel: int

proc assertEquals[T, U](expected: T, actual: U, message = "") =
  if expected != actual:
    echo "Error: Not equal! Expected ", expected, " got ", actual, ". ",
      "Message: ", message
    assert false

proc testCodec(image: Image, expectedBpp: int) =
  echo "w: $1, h: $2, expectedBpp: $3" % [$image.width, $image.height, $expectedBpp]
  var s = newStringStream()
  s.encodeBMP(image.data, image.width, image.height, image.bitsPerPixel)
  s.setPosition 0

  var bmp = s.decodeBMP()
  assertEquals(bmp.width, image.width)
  assertEquals(bmp.height, image.height)
  assertEquals(bmp.bitsPerPixel, expectedBpp)

  var data = convert[string](bmp, 24)
  assertEquals(data.data, image.data)

proc testCodec() =
  var image: Image
  image.width = 128
  image.height = 128
  image.bitsPerPixel = 24
  image.data = newString(image.width * image.height * 3)

  let size = image.width * image.height
  for i in 0..<size:
    let px = i * 3
    image.data[px] = chr(i mod 2)
    image.data[px + 1] = chr(0)
    image.data[px + 2] = chr(0)

  testCodec(image, 1)

  for i in 0..<size:
    let px = i * 3
    image.data[px] = chr(i mod 16)
    image.data[px + 1] = chr(0)
    image.data[px + 2] = chr(0)

  testCodec(image, 4)

  for i in 0..<size:
    let px = i * 3
    image.data[px] = chr(i mod 256)
    image.data[px + 1] = chr(0)
    image.data[px + 2] = chr(0)

  testCodec(image, 8)

  var
    r = 0
    g = 0
    b = 0

  for i in 0..<size:
    let px = i * 3
    image.data[px] = chr(r)
    image.data[px + 1] = chr(g)
    image.data[px + 2] = chr(b)
    inc r
    if r >= 256:
      inc g
      r = 0
    if g >= 256:
      inc b
      g = 0
    if b >= 256:
      b = 0

  testCodec(image, 24)

  #this one must be visually inspected because of lossy algorithm
  var bmp = loadBMP8("bmptestsuite-0.9"&DirSep&"valid"&DirSep&"24bpp-320x240.bmp")
  saveBMP8("8bpp.bmp", bmp.data, bmp.width, bmp.height)

testCodec()
