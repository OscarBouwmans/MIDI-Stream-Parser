
public protocol MIDIChannelVoiceMessage: MIDIMessage {
    var channel: UInt8 { get }
}

extension MIDIChannelVoiceMessage {
    public var channel: UInt8 {
        get {
            return bytes[0] & 0x0F
        }
    }
}

public protocol MIDINoteMessage: MIDIChannelVoiceMessage {
    var note: UInt8 { get }
    var velocity: UInt8 { get }
}

extension MIDINoteMessage {
    public var note: UInt8 { bytes[1] }
    public var velocity: UInt8 { bytes[2] }
}

public struct MIDINoteOffMessage: MIDINoteMessage {
    public var type: MIDIMessageType { .noteOff }
    public let bytes: [UInt8]
}

extension MIDINoteOffMessage {
    public init(channel: UInt8, note: UInt8, velocity: UInt8) throws {
        try validate(channel: channel)
        try validate(valueByte: note)
        try validate(valueByte: velocity)
        self.init(bytes: [128 + channel, note, velocity])
    }
}

public struct MIDINoteOnMessage: MIDINoteMessage {
    public var type: MIDIMessageType { .noteOn }
    public let bytes: [UInt8]
}

extension MIDINoteOnMessage {
    public init(channel: UInt8, note: UInt8, velocity: UInt8) throws {
        try validate(channel: channel)
        try validate(valueByte: note)
        try validate(valueByte: velocity)
        self.init(bytes: [144 + channel, note, velocity])
    }
}

public struct MIDIPolyphonicKeyPressureMessage: MIDIChannelVoiceMessage {
    public var type: MIDIMessageType { .polyphonicKeyPressure }
    public let bytes: [UInt8]
    
    public var note: UInt8 { bytes[1] }
    public var pressure: UInt8 { bytes[2] }
}

extension MIDIPolyphonicKeyPressureMessage {
    public init(channel: UInt8, note: UInt8, pressure: UInt8) throws {
        try validate(channel: channel)
        try validate(valueByte: note)
        try validate(valueByte: pressure)
        self.init(bytes: [160 + channel, note, pressure])
    }
}

public struct MIDIControlChangeMessage: MIDIChannelVoiceMessage {
    public var type: MIDIMessageType { .controlChange }
    public let bytes: [UInt8]
    
    public var controller: UInt8 { bytes[1] }
    public var value: UInt8 { bytes[2] }
}

extension MIDIControlChangeMessage {
    public init(channel: UInt8, controller: UInt8, value: UInt8) throws {
        try validate(channel: channel)
        try validate(valueByte: controller)
        try validate(valueByte: value)
        self.init(bytes: [176 + channel, controller, value])
    }
}

public struct MIDIProgramChangeMessage: MIDIChannelVoiceMessage {
    public var type: MIDIMessageType { .programChange }
    public let bytes: [UInt8]
    
    public var program: UInt8 { bytes[1] }
}

extension MIDIProgramChangeMessage {
    public init(channel: UInt8, program: UInt8) throws {
        try validate(channel: channel)
        try validate(valueByte: program)
        self.init(bytes: [192 + channel, program])
    }
}

public struct MIDIChannelPressureMessage: MIDIChannelVoiceMessage {
    public var type: MIDIMessageType { .channelPressure }
    public let bytes: [UInt8]
    
    public var pressure: UInt8 { bytes[1] }
}

extension MIDIChannelPressureMessage {
    public init(channel: UInt8, pressure: UInt8) throws {
        try validate(channel: channel)
        try validate(valueByte: pressure)
        self.bytes = [208 + channel, pressure]
    }
}

public struct MIDIPitchBendMessage: MIDIChannelVoiceMessage {
    public var type: MIDIMessageType { .pitchBend }
    public let bytes: [UInt8]
    
    public var lsb: UInt8 { bytes[1] }
    public var msb: UInt8 { bytes[2] }
    public var value: UInt16 { UInt16(msb) << 7 + UInt16(lsb) }
}

extension MIDIPitchBendMessage {
    public init(channel: UInt8, value: UInt16) throws {
        try validate(channel: channel)
        try validate(highResultionValueByte: value)
        let mostSignificant7Bits = UInt8(value >> 7)
        let leastSignificant8Bits = UInt8(value & 127)
        self.bytes = [224 + channel, leastSignificant8Bits, mostSignificant7Bits]
    }
}
