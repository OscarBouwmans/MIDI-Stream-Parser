
extension MIDIStreamParser {
    static func statusSystemExclusiveParser(statusByte: UInt8, payload: [UInt8] = []) -> MIDIParserResult {
        func subParse(byte: UInt8, _: UInt8? = nil) -> MIDIParserResult {
            var bytes = payload
            if byte == MIDIMessageType.endOfExclusive.rawValue {
                guard bytes.count > 0 else {
                    return MIDIParserResult.None
                }
                bytes.insert(statusByte, at: 0)
                bytes.append(byte)
                return MIDIParserResult(message: MIDISystemExclusiveMessage(bytes: bytes))
            }
            guard byte < 128 else {
                // if interrupted by a SystemRealTimeMessage, we must return that message and continue our SysEx parsing
                
                switch byte {
                case MIDIMessageType.timingClock.rawValue:
                    return MIDIParserResult(interrupting: MIDITimingClockMessage(), nextParser: subParse)
                case MIDIMessageType.start.rawValue:
                    return MIDIParserResult(interrupting: MIDIStartMessage(), nextParser: subParse)
                case MIDIMessageType.continue.rawValue:
                    return MIDIParserResult(interrupting: MIDIContinueMessage(), nextParser: subParse)
                case MIDIMessageType.stop.rawValue:
                    return MIDIParserResult(interrupting: MIDIStopMessage(), nextParser: subParse)
                case MIDIMessageType.activeSensing.rawValue:
                    return MIDIParserResult(interrupting: MIDIActiveSensingMessage(), nextParser: subParse)
                case MIDIMessageType.systemReset.rawValue:
                    return MIDIParserResult(interrupting: MIDIResetMessage(), nextParser: subParse)
                default:
                    // any other non-value byte invalidates our SysEx and should be interpreted as a new message:
                    return selectNextParser(statusByte: byte)
                }
            }
            bytes.append(byte)
            return MIDIStreamParser.statusSystemExclusiveParser(statusByte: statusByte, payload: bytes)
        }
        
        return MIDIParserResult { (byte, _) in
            subParse(byte: byte)
        }
    }
}
