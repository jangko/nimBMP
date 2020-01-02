import nimBMP, os, strutils, minibmp, terminal

when false:
  import nimPNG

  proc convertPNG(src, dest: string) =
    var png = loadPNG24(src)
    echo png.data.len, " ", png.width, " ", png.height
    let miniBMP = newMiniBMP(png.data, png.width, png.height)
    miniBMP.save(dest)

  proc convertPNG(suite: string) =
    let baseDir = "bmptestsuite-0.9" & DirSep
    let suiteDir = baseDir & suite
    for fileName in walkDirRec(suiteDir, {pcFile}):
      let path = splitFile(fileName)
      if path.ext.len() == 0: continue
      let ext = toLowerAscii(path.ext)
      if ext != ".png": continue

      let bmpName = path.dir & DirSep & "compare24" & DirSep & path.name & ExtSep & "bmp"
      echo fileName
      echo bmpName
      convertPNG(fileName, bmpName)

  proc convert() =
    convertPNG("corrupt")
    convertPNG("questionable")
    convertPNG("valid")

  convert()

proc compareFile(src, tgt: string): bool =
  var bmp = loadBMP24(src)
  if not fileExists(tgt) and bmp.data.len == 0:
    return true

  if bmp.data.len == 0: return false
  let miniBMP = newMiniBMP(bmp.data, bmp.width, bmp.height)
  let target = readFile(tgt)
  result = miniBMP.compare(target)

proc compareSuite*(baseDir, suite: string): bool =
  result = true
  let suiteDir = baseDir & suite
  let compareDir = suiteDir & DirSep & "compare24" & DirSep
  let ext = ExtSep & "bmp"

  stdout.styledWriteLine(fgCyan, suite)
  for kind, fileName in walkDir(suiteDir):
    if kind notin {pcFile}: continue
    let path = splitFile(fileName)
    if path.ext.len() == 0: continue

    let ext = toLowerAscii(path.ext)
    if ext != ".bmp": continue
    if path.name[0] == 'x': continue

    let cmpName = compareDir & path.name & ext
    if compareFile(fileName, cmpName):
      stdout.styledWriteLine("  ", path.name, "...", fgGreen, "[PASS]")
    else:
      stdout.styledWriteLine("  ", path.name, "...", fgRed, "[FAILED]")
      result = false

when isMainModule:
  proc main() =
    var success = true
    let baseDir = "bmptestsuite-0.9" & DirSep

    success = success and compareSuite(baseDir, "corrupt")
    success = success and compareSuite(baseDir, "questionable")
    success = success and compareSuite(baseDir, "valid")
    quit(if success: 0 else: -1)

  main()
