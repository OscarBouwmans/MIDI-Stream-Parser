
protocol MidiMessage: Sendable {
    var type: MidiMessageType { get }
    var bytes: [UInt8] { get }
    
    init(bytes: [UInt8])
}

extension MidiMessage {
    private init(bytes: [UInt8]) {
        self.init(bytes: bytes)
    }
}
