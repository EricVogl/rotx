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
#   cthulhux x message - rotates each character in message by x, only affects alpha characters, adds random words from the ELDER GODS
#
# Author:
#   Eric Vogl

module.exports = (robot) ->
  upperMin = "A".charCodeAt(0)
  upperMax = "Z".charCodeAt(0)
  lowerMin = "a".charCodeAt(0)
  lowerMax = "z".charCodeAt(0)
  cthulhuWords = ["ph'nglui", "mglw'nafh", "Cthulhu", "R'lyeh", "wgah'nagl", "fhtagn"]

  robot.respond /rotx (-{0,1}\d+) (.+)/i, (msg) ->
    rotation = parseInt(msg.match[1])
    message = msg.match[2]
    rotatedMessage = rotateMessage(rotation, message)
    msg.send rotatedMessage

  robot.respond /cthul[h]{0,1}ux (-{0,1}\d+) (.+)/i, (msg) ->
    rotation = parseInt(msg.match[1])
    message = msg.match[2]
    rotatedMessage = rotateMessage(rotation, message)
    words = rotatedMessage.split(" ")
    cthulhuMessage = ""
    for word in words
      cthulhuMessage = cthulhuMessage + word + " "
      cthulhuMessage = cthulhuMessage + cthulhuWords[randomInt(0, cthulhuWords.length - 1)] + " " if randomInt(1, 2) > 1

    msg.send "https://hipchat.solium.com/files/1/13/VMBDVBNxomN7TAg/cthulhu.jpg"
    msg.send cthulhuMessage.trim()

  rotateMessage = (rotation, message) ->
    rotatedMessage = ""
    for ch in message
      rotatedCh = rotx(rotation, ch)
      rotatedMessage = rotatedMessage + rotatedCh
    return rotatedMessage

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

  randomInt = (lower, upper) ->
    [lower, upper] = [0, lower]     unless upper?           # Called with one argument
    [lower, upper] = [upper, lower] if lower > upper        # Lower must be less then upper
    Math.floor(Math.random() * (upper - lower + 1) + lower) # Last statement is a return value
