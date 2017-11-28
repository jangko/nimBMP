import nimBMP, os, strutils, nimPNG

proc convert(src, dest: string) =
  var bmp = loadBMP24(src)
  if bmp.data != nil:
    discard savePNG24(dest, bmp.data, bmp.width, bmp.height)
    
proc convert(dir: string) =
  for fileName in walkDirRec(dir, {pcFile}):
    let path = splitFile(fileName)
    if path.ext.len() == 0: continue

    let ext = toLowerAscii(path.ext)
    if ext != ".bmp": continue
    if path.name[0] == 'x': continue

    let pngName = path.dir & DirSep & path.name & ExtSep & "png"
    echo path.name
    convert(fileName, pngName)
    
convert("bmptestsuite-0.9" & DirSep & "corrupt")
convert("bmptestsuite-0.9" & DirSep & "questionable")
convert("bmptestsuite-0.9" & DirSep & "valid")
