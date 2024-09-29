
protocol MidiChannelVoiceMessage: MidiMessage {
    var channel: UInt8 { get }
}

extension MidiChannelVoiceMessage {
    var channel: UInt8 {
        get {
            return bytes[0] & 0x0F
        }
    }
}

protocol MidiNoteMessage: MidiChannelVoiceMessage {
    var note: UInt8 { get }
    var velocity: UInt8 { get }
}

extension MidiNoteMessage {
    var note: UInt8 { bytes[1] }
    var velocity: UInt8 { bytes[2] }
}

struct MidiNoteOffMessage: MidiNoteMessage {
    var type: MidiMessageType { .noteOff }
    let bytes: [UInt8]
}

extension MidiNoteOffMessage {
    public init(channel: UInt8, note: UInt8, velocity: UInt8) throws {
        try validate(channel: channel)
        try validate(valueByte: note)
        try validate(valueByte: velocity)
        self.init(bytes: [128 + channel, note, velocity])
    }
}

struct MidiNoteOnMessage: MidiNoteMessage {
    var type: MidiMessageType { .noteOn }
    let bytes: [UInt8]
}

extension MidiNoteOnMessage {
    public init(channel: UInt8, note: UInt8, velocity: UInt8) throws {
        try validate(channel: channel)
        try validate(valueByte: note)
        try validate(valueByte: velocity)
        self.init(bytes: [144 + channel, note, velocity])
    }
}

struct MidiPolyphonicKeyPressureMessage: MidiChannelVoiceMessage {
    var type: MidiMessageType { .polyphonicKeyPressure }
    let bytes: [UInt8]
    
    public var note: UInt8 { bytes[1] }
    public var pressure: UInt8 { bytes[2] }
}

extension MidiPolyphonicKeyPressureMessage {
    public init(channel: UInt8, note: UInt8, pressure: UInt8) throws {
        try validate(channel: channel)
        try validate(valueByte: note)
        try validate(valueByte: pressure)
        self.init(bytes: [160 + channel, note, pressure])
    }
}

struct MidiControlChangeMessage: MidiChannelVoiceMessage {
    var type: MidiMessageType { .controlChange }
    let bytes: [UInt8]
    
    public var controller: UInt8 { bytes[1] }
    public var value: UInt8 { bytes[2] }
}

extension MidiControlChangeMessage {
    public init(channel: UInt8, controller: UInt8, value: UInt8) throws {
        try validate(channel: channel)
        try validate(valueByte: controller)
        try validate(valueByte: value)
        self.init(bytes: [176 + channel, controller, value])
    }
}

struct MidiProgramChangeMessage: MidiChannelVoiceMessage {
    var type: MidiMessageType { .programChange }
    let bytes: [UInt8]
    
    public var program: UInt8 { bytes[1] }
}

extension MidiProgramChangeMessage {
    public init(channel: UInt8, program: UInt8) throws {
        try validate(channel: channel)
        try validate(valueByte: program)
        self.init(bytes: [192 + channel, program])
    }
}

struct MidiChannelPressureMessage: MidiChannelVoiceMessage {
    var type: MidiMessageType { .channelPressure }
    let bytes: [UInt8]
    
    public var pressure: UInt8 { bytes[1] }
}

extension MidiChannelPressureMessage {
    public init(channel: UInt8, pressure: UInt8) throws {
        try validate(channel: channel)
        try validate(valueByte: pressure)
        self.bytes = [208 + channel, pressure]
    }
}

struct MidiPitchBendMessage: MidiChannelVoiceMessage {
    var type: MidiMessageType { .pitchBend }
    let bytes: [UInt8]
    
    public var lsb: UInt8 { bytes[1] }
    public var msb: UInt8 { bytes[2] }
    public var value: UInt16 { UInt16(msb) << 7 + UInt16(lsb) }
}

extension MidiPitchBendMessage {
    public init(channel: UInt8, value: UInt16) throws {
        try validate(channel: channel)
        try validate(highResultionValueByte: value)
        let mostSignificant7Bits = UInt8(value >> 7)
        let leastSignificant8Bits = UInt8(value & 127)
        self.bytes = [224 + channel, leastSignificant8Bits, mostSignificant7Bits]
    }
}
