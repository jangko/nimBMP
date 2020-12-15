packageName   = "nimBMP"
version       = "0.1.8"
author        = "Andri Lim"
description   = "BMP encoder and decoder"
license       = "MIT"
skipDirs      = @["tests", "manual"]

requires: "nim >= 1.0.2"

### Helper functions
proc test(env, path: string) =
  # Compilation language is controlled by TEST_LANG
  var lang = "c"
  if existsEnv"TEST_LANG":
    lang = getEnv"TEST_LANG"

  if not dirExists "build":
    mkDir "build"
  exec "nim " & lang & " " & env &
    " --outdir:build -r --hints:off --warnings:off " & path

task tests, "Run tests":
  test "-d:debug", "tests/test_codec.nim"
  test "-d:debug", "tests/test_suite.nim"
  test "-d:debug", "tests/test_misc.nim"

  test "-d:release", "tests/test_codec.nim"
  test "-d:release", "tests/test_suite.nim"
  test "-d:release", "tests/test_misc.nim"

  test "-d:release --gc:arc", "tests/test_codec.nim"
  test "-d:release --gc:arc", "tests/test_suite.nim"
  test "-d:release --gc:arc", "tests/test_misc.nim"
