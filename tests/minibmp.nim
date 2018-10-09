import streams

type
  MiniBMP* = ref object
    width*, height*: int
    data*: string

proc writeWORD(s: Stream, val: int) =
  let word = val.int16
  s.write(word)

proc writeDWORD(s: Stream, val: int) =
  let dword = val.int32
  s.write(dword)

proc newMiniBMP*(data: string, w, h: int): MiniBMP =
  new(result)
  result.width = w
  result.height = h
  shallowCopy(result.data, data)

proc writeBMP*(s: Stream, bmp: MiniBMP) =
  let stride    = 4 * ((bmp.width * 24 + 31) div 32)
  let imageData = stride * bmp.height
  let offset    = 54
  var fileSize  = imageData + offset
  s.writeWORD(19778)
  s.writeDWORD(fileSize)
  s.writeWORD(0)
  s.writeWORD(0)
  s.writeDWORD(offset)
  s.writeDWORD(40)
  s.writeDWORD(bmp.width)
  s.writeDWORD(bmp.height)
  s.writeWORD(1)
  s.writeWORD(24)
  s.writeDWORD(0)
  s.writeDWORD(imageData)
  s.writeDWORD(3780)
  s.writeDWORD(3780)
  s.writeDWORD(0)
  s.writeDWORD(0)

  let bytesPerRow = bmp.width * 3
  let paddingLen  = stride - bytesPerRow
  let padding     = if paddingLen > 0: newString(paddingLen) else: ""

  for i in 0..bmp.height-1:
    s.writeData(addr(bmp.data[i * bytesPerRow]), bytesPerRow)
    if paddingLen > 0: s.write(padding)

proc compare*(bmp: MiniBMP, data: string): bool =
  var s = newStringStream()
  s.writeBMP(bmp)
  result = s.data == data

proc save*(bmp: MiniBMP, fileName: string) =
  var s = newFileStream(fileName, fmWrite)
  s.writeBMP(bmp)
  s.close()
