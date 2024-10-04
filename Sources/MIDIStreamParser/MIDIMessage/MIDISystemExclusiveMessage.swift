
struct MIDISystemExclusiveMessage: MIDIMessage {
    var type: MIDIMessageType { .systemExclusive }
    let bytes: [UInt8]
    
    var payload: [UInt8] { Array(bytes[1..<bytes.count-1]) }
}

extension MIDISystemExclusiveMessage {
    init(payload: [UInt8]) {
        self.init(bytes: [0xF0] + payload + [0xF7])
    }
}
