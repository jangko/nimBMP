import nimBMP, streams, strutils, os, testSuite, terminal

type
  Image = object
    data: string
    width, height: int
    bitsPerPixel: int

proc assertEquals[T, U](expected: T, actual: U, message = ""): bool =
  if expected != actual:
    stdout.styledWriteLine("  ", message, "Error: Not equal! Expected ", $expected, " got ", $actual, "...", fgRed, "[FAILED]")
    return false
  else:
    stdout.styledWriteLine("  ", message, " Expected ", $expected, " got ", $actual, "...", fgGreen, "[PASS]")
    return true

proc testCodec(image: Image, expectedBpp: int): bool =
  echo "  w: $1, h: $2, expectedBpp: $3" % [$image.width, $image.height, $expectedBpp]
  var s = newStringStream()
  s.encodeBMP(image.data, image.width, image.height, image.bitsPerPixel)
  s.setPosition 0

  var bmp = s.decodeBMP()
  var success = true
  success = success and assertEquals(bmp.width, image.width, "width")
  success = success and assertEquals(bmp.height, image.height, "height")
  success = success and assertEquals(bmp.bitsPerPixel, expectedBpp, "bpp")

  var data = convert[string](bmp, 24)
  success = success and assertEquals(data.data.len, image.data.len, "dataLen")
  if data.data != image.data:
    success = success and assertEquals("bad data", "good data", "data")

  result = success

proc testCodec(): bool =
  stdout.styledWriteLine(fgCyan, "codec")
  var success = true
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

  success = success and testCodec(image, 1)

  for i in 0..<size:
    let px = i * 3
    image.data[px] = chr(i mod 16)
    image.data[px + 1] = chr(0)
    image.data[px + 2] = chr(0)

  success = success and testCodec(image, 4)

  for i in 0..<size:
    let px = i * 3
    image.data[px] = chr(i mod 256)
    image.data[px + 1] = chr(0)
    image.data[px + 2] = chr(0)

  success = success and testCodec(image, 8)

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

  success = success and testCodec(image, 24)
  result = success

when false:
  import minibmp
  var bmp = loadBMP24("gray\\8bpp.bmp")
  let mini = newMiniBMP(bmp.data, bmp.width, bmp.height)
  mini.save("gray\\compare24\\8bpp.bmp")

proc testGray(): bool =
  let graySuite = "gray"
  createDir(graySuite)
  let suiteDir = ".." & DirSep & "bmptestsuite-0.9" & DirSep
  var bmp = loadBMP8(suiteDir & "valid" & DirSep & "24bpp-320x240.bmp")

  saveBMP8(graySuite & DirSep & "8bpp.bmp", bmp.data, bmp.width, bmp.height)
  let baseDir = "." & DirSep
  compareSuite(baseDir, graySuite)

when isMainModule:
  proc main() =
    var success = true
    success = success and testCodec()
    success = success and testGray()
    quit(if success: 0 else: -1)

  main()
