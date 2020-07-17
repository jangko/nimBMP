import ../nimBMP, os, unittest

const testFolder = "misc"

suite "misc test":
  test "1bit":
    var bmp = loadBMP24(testFolder / "1bit.bmp")
    check bmp.width == 96
    check bmp.height == 16

  test "4bit":
    var bmp = loadBMP24(testFolder / "4bit.bmp")
    check bmp.width == 134
    check bmp.height == 38

  test "8bit":
    var bmp = loadBMP24(testFolder / "8bit.bmp")
    check bmp.width == 216
    check bmp.height == 143
