
public protocol MIDIMessage: Sendable {
    var type: MIDIMessageType { get }
    var bytes: [UInt8] { get }
}
