
extension MIDIStreamParser {
    static func statusNoteOffParser(statusByte: UInt8) -> MIDIParserResult {
        return valueByteGuard { (note, _) in
            valueByteGuard { (velocity, _) in
                MIDIParserResult(message: MIDINoteOffMessage(bytes: [statusByte, note, velocity]))
            }
        }
    }
    
    static func statusNoteOnParser(statusByte: UInt8) -> MIDIParserResult {
        return valueByteGuard { (note, _) in
            valueByteGuard { (velocity, _) in
                MIDIParserResult(message: MIDINoteOnMessage(bytes: [statusByte, note, velocity]))
            }
        }
    }
    
    static func statusPolyphonicKeyPressureParser(statusByte: UInt8) -> MIDIParserResult {
        return MIDIStreamParser.valueByteGuard { (note, _) in
            MIDIStreamParser.valueByteGuard { (pressure, _) in
                MIDIParserResult(message: MIDIPolyphonicKeyPressureMessage(bytes: [statusByte, note, pressure]))
            }
        }
    }
    
    static func statusControlChangeParser(statusByte: UInt8) -> MIDIParserResult {
        return MIDIStreamParser.valueByteGuard { (controller, _) in
            MIDIStreamParser.valueByteGuard { (value, _) in
                MIDIParserResult(message: MIDIControlChangeMessage(bytes: [statusByte, controller, value]))
            }
        }
    }
    
    static func statusProgramChangeParser(statusByte: UInt8) -> MIDIParserResult {
        return MIDIStreamParser.valueByteGuard { (program, _) in
            MIDIParserResult(message: MIDIProgramChangeMessage(bytes: [statusByte, program]))
        }
    }
    
    static func statusChannelPressureParser(statusByte: UInt8) -> MIDIParserResult {
        return MIDIStreamParser.valueByteGuard { (pressure, _) in
            MIDIParserResult(message: MIDIChannelPressureMessage(bytes: [statusByte, pressure]))
        }
    }
    
    static func statusPitchBendParser(statusByte: UInt8) -> MIDIParserResult {
        return MIDIStreamParser.valueByteGuard { (lsb, _) in
            MIDIStreamParser.valueByteGuard { (msb, _) in
                MIDIParserResult(message: MIDIPitchBendMessage(bytes: [statusByte, lsb, msb]))
            }
        }
    }
}
