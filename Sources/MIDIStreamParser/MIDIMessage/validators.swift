
internal func validate(channel: UInt8) throws {
    guard channel < 16 else {
        throw MidiMessageError.invalidChannelNumber
    }
}

internal func validate(valueByte: UInt8) throws {
    guard valueByte < 128 else {
        throw MidiMessageError.invalidValue
    }
}

internal func validate(highResultionValueByte: UInt16) throws {
    guard highResultionValueByte < 8192 else {
        throw MidiMessageError.invalidValue
    }
}
