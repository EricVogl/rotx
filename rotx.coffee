# Description:
#   Rotx For Your Encryption Needs(tm)
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   rotx x message - rotates each character in message by x, only affects alpha characters
#
# Author:
#   Eric Vogl

module.exports = (robot) ->
  upperMin = "A".charCodeAt(0)
  upperMax = "Z".charCodeAt(0)
  lowerMin = "a".charCodeAt(0)
  lowerMax = "z".charCodeAt(0)

  robot.respond /rotx (-{0,1}\d+) (.+)/i, (msg) ->
    rotation = parseInt(msg.match[1])
    message = msg.match[2]
    rotatedMessage = ""
    for ch in message
      rotatedCh = rotx(rotation, ch, msg)
      rotatedMessage = rotatedMessage + rotatedCh
    msg.send rotatedMessage

  rotx = (rotation, ch) ->
    charCode = ch.charCodeAt(0)
    if lowerMin <= charCode <= lowerMax
      return rotChar(rotation, charCode, lowerMin, lowerMax - lowerMin + 1)
    if upperMin <= charCode <= upperMax
      return rotChar(rotation, charCode, upperMin, upperMax - upperMin + 1)
    return ch

  rotChar = (rotation, charCode, baseCharCode, setSize) ->
    rotation = setSize + (rotation % setSize) # handle negatives
    newCode = baseCharCode + (charCode - baseCharCode + rotation) % setSize
    return String.fromCharCode(newCode)
