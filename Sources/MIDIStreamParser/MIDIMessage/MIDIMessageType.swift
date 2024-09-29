
enum MidiMessageType: UInt8 {
    case noteOff = 0x80
    case noteOn = 0x90
    case polyphonicKeyPressure = 0xA0
    case controlChange = 0xB0
    case programChange = 0xC0
    case channelPressure = 0xD0
    case pitchBend = 0xE0
    case systemExclusive = 0xF0
    case timeCodeQuarterFrame = 0xF1
    case songPositionPointer = 0xF2
    case songSelect = 0xF3
    case tuneRequest = 0xF6
    case endOfExclusive = 0xF7
    case timingClock = 0xF8
    case start = 0xFA
    case `continue` = 0xFB
    case stop = 0xFC
    case activeSensing = 0xFE
    case systemReset = 0xFF
}
