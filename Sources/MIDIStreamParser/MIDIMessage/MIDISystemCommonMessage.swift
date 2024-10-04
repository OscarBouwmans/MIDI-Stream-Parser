
protocol MIDISystemCommonMessage: MIDIMessage {}

struct MidiTimeCodeQuarterFrameMessage: MIDISystemCommonMessage {
    var type: MIDIMessageType { .timeCodeQuarterFrame }
    let bytes: [UInt8]
    
    public var quarterFrameType: QuarterFrameType { .init(rawValue: bytes[1] >> 4)! }
    // todo: elegant way to read the second half of byte[1]
    
    enum QuarterFrameType: UInt8 {
        case frameNumberLsb = 0x00
        case frameNumberMsb = 0x10
        case secondLsb = 0x20
        case secondMsb = 0x30
        case minuteLsb = 0x40
        case minuteMsb = 0x50
        case hourLsb = 0x60
        case hourMsbAndRate = 0x70
    }

    enum FrameRate: UInt8 {
        case r24 = 0x00
        case r25 = 0x02
        case r29 = 0x04
        case r30 = 0x06
    }
}

extension MidiTimeCodeQuarterFrameMessage {
    public init(frameNumberLsb: UInt8) throws {
        guard frameNumberLsb < 0x80 else { throw MIDIMessageError.invalidValue }
        self.init(bytes: [0xF1, QuarterFrameType.frameNumberLsb.rawValue + frameNumberLsb])
    }
    public init(frameNumberMsb: UInt8) throws {
        guard frameNumberMsb < 0x02 else { throw MIDIMessageError.invalidValue }
        self.init(bytes: [0xF1, QuarterFrameType.frameNumberMsb.rawValue + frameNumberMsb])
    }
    public init(secondLsb: UInt8) throws {
        guard secondLsb < 0x80 else { throw MIDIMessageError.invalidValue }
        self.init(bytes: [0xF1, QuarterFrameType.secondLsb.rawValue + secondLsb])
    }
    public init(secondMsb: UInt8) throws {
        guard secondMsb < 0x04 else { throw MIDIMessageError.invalidValue }
        self.init(bytes: [0xF1, QuarterFrameType.secondMsb.rawValue + secondMsb])
    }
    public init(minuteLsb: UInt8) throws {
        guard minuteLsb < 0x80 else { throw MIDIMessageError.invalidValue }
        self.init(bytes: [0xF1, QuarterFrameType.minuteLsb.rawValue + minuteLsb])
    }
    public init(minuteMsb: UInt8) throws {
        guard minuteMsb < 0x04 else { throw MIDIMessageError.invalidValue }
        self.init(bytes: [0xF1, QuarterFrameType.minuteMsb.rawValue + minuteMsb])
    }
    public init(hourLsb: UInt8) throws {
        guard hourLsb < 0x80 else { throw MIDIMessageError.invalidValue }
        self.init(bytes: [0xF1, QuarterFrameType.hourLsb.rawValue + hourLsb])
    }
    public init(hourMsb: UInt8, rate: FrameRate) throws {
        guard hourMsb < 0x02 else { throw MIDIMessageError.invalidValue }
        self.init(bytes: [0xF1, QuarterFrameType.hourMsbAndRate.rawValue + rate.rawValue])
    }
}

struct MidiSongPositionPointerMessage: MIDISystemCommonMessage {
    var type: MIDIMessageType { .songPositionPointer }
    let bytes: [UInt8]
    
    public var lsb: UInt8 { bytes[1] }
    public var msb: UInt8 { bytes[2] }
//    public var value: UInt16 { UInt16(msb) << 8 + UInt16(lsb) }
}

extension MidiSongPositionPointerMessage {
    
}

struct MidiSongSelect: MIDISystemCommonMessage {
    var type: MIDIMessageType { .songSelect }
    let bytes: [UInt8]
    
    public var song: UInt8 { bytes[1] }
}

struct MidiTuneRequest: MIDISystemCommonMessage {
    var type: MIDIMessageType { .tuneRequest }
    let bytes: [UInt8]
}
