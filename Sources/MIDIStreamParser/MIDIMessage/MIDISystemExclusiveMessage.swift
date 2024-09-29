
struct MidiSystemExclusiveMessage: MidiMessage {
    var type: MidiMessageType { .systemExclusive }
    let bytes: [UInt8]
    
    var payload: [UInt8] { Array(bytes[1..<bytes.count-1]) }
}

extension MidiSystemExclusiveMessage {
    init(payload: [UInt8]) {
        self.init(bytes: [0xF0] + payload + [0xF7])
    }
}
