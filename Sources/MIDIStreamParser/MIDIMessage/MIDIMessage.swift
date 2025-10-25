
public protocol MIDIMessage: Sendable, Codable {
    var type: MIDIMessageType { get }
    var bytes: [UInt8] { get }
}
