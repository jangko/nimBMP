packageName   = "nimBMP"
version       = "0.1.7"
author        = "Andri Lim"
description   = "BMP encoder and decoder"
license       = "MIT"
skipDirs      = @["tests", "manual"]

requires: "nim >= 1.0.2"

task tests, "Run tests":
  withDir("tests"):
    exec "nim c -r testCodec.nim"
    exec "nim c -r testSuite.nim"

    exec "nim c -r -d:release testCodec.nim"
    exec "nim c -r -d:release testSuite.nim"
