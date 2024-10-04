
internal func validate(channel: UInt8) throws {
    guard channel < 16 else {
        throw MIDIMessageError.invalidChannelNumber
    }
}

internal func validate(valueByte: UInt8) throws {
    guard valueByte < 128 else {
        throw MIDIMessageError.invalidValue
    }
}

internal func validate(highResultionValueByte: UInt16) throws {
    guard highResultionValueByte < 16_384 else {
        throw MIDIMessageError.invalidValue
    }
}
