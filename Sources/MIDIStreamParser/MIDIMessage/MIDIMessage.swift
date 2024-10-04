
protocol MIDIMessage: Sendable {
    var type: MIDIMessageType { get }
    var bytes: [UInt8] { get }
    
    init(bytes: [UInt8])
}

extension MIDIMessage {
    private init(bytes: [UInt8]) {
        self.init(bytes: bytes)
    }
}