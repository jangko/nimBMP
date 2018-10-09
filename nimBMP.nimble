packageName   = "nimBMP"
version       = "0.1.6"
author        = "Andri Lim"
description   = "BMP encoder and decoder"
license       = "MIT"
skipDirs      = @["test", "manual", "bmptestsuite-0.9"]

requires: "nim >= 0.18.1"

task tests, "Run tests":
  withDir("tests"):
    exec "nim c -r testCodec.nim"
    exec "nim c -r testSuite.nim"

    exec "nim c -r -d:release testCodec.nim"
    exec "nim c -r -d:release testSuite.nim"
