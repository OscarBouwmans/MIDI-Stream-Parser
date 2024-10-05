
extension MIDIStreamParser {
    static func statusSystemExclusiveParser(statusByte: UInt8, payload: [UInt8] = []) -> MIDIParserResult {
        return MIDIParserResult { (byte, _) in
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
                return selectNextParser(statusByte: byte)
            }
            bytes.append(byte)
            return MIDIStreamParser.statusSystemExclusiveParser(statusByte: statusByte, payload: bytes)
        }
    }
}
