
protocol MIDISystemCommonMessage: MIDIMessage {}

struct MIDISystemExclusiveMessage: MIDISystemCommonMessage {
    var type: MIDIMessageType { .systemExclusive }
    let bytes: [UInt8]
    
    var payload: [UInt8] { Array(bytes[1..<bytes.count-1]) }
}

extension MIDISystemExclusiveMessage {
    init(payload: [UInt8]) throws {
        guard !payload.isEmpty else {
            throw MIDIMessageError.invalidValue
        }
        self.init(bytes: [0xF0] + payload + [0xF7])
    }
}

struct MIDITimeCodeQuarterFrameMessage: MIDISystemCommonMessage {
    var type: MIDIMessageType { .timeCodeQuarterFrame }
    let bytes: [UInt8]
    
    var value: MIDITimeCodeQuarterFrameData { return try! .init(from: bytes[1]) }
}

public enum MIDITimeCodeQuarterFrameData: Equatable {
    case frameLsb(lsb: UInt8)
    case frameMsb(msb: UInt8)
    case secondLsb(lsb: UInt8)
    case secondMsb(msb: UInt8)
    case minuteLsb(lsb: UInt8)
    case minuteMsb(msb: UInt8)
    case hourLsb(lsb: UInt8)
    case hourMsb(msb: UInt8, rate: MIDITimeCodeFrameRate)
    
    private var offset: UInt8 {
        switch self {
        case .frameLsb: return 0x00
        case .frameMsb: return 0x10
        case .secondLsb: return 0x20
        case .secondMsb: return 0x30
        case .minuteLsb: return 0x40
        case .minuteMsb: return 0x50
        case .hourLsb: return 0x60
        case .hourMsb: return 0x70
        }
    }
    
    public var byteValue: UInt8 {
        switch self {
        case .frameLsb(let value), .frameMsb(let value),
                .secondLsb(let value), .secondMsb(let value),
                .minuteLsb(let value), .minuteMsb(let value),
                .hourLsb(let value):
            return offset + value
        case .hourMsb(let msb, let rate):
            return offset + (rate.rawValue << 1) + msb
        }
    }
    
    public init(from byte: UInt8) throws {
        try validate(valueByte: byte)
        let offset = byte & 0x70
        switch offset {
        case 0x00: self = .frameLsb(lsb: byte & 0x0F)
        case 0x10: self = .frameMsb(msb: byte & 0x0F)
        case 0x20: self = .secondLsb(lsb: byte & 0x0F)
        case 0x30: self = .secondMsb(msb: byte & 0x0F)
        case 0x40: self = .minuteLsb(lsb: byte & 0x0F)
        case 0x50: self = .minuteMsb(msb: byte & 0x0F)
        case 0x60: self = .hourLsb(lsb: byte & 0x0F)
        case 0x70:
            guard let rate = MIDITimeCodeFrameRate.init(rawValue: (byte & 0x06) >> 1) else {
                throw MIDIMessageError.invalidValue
            }
            self = .hourMsb(msb: byte & 0x01, rate: rate)
        default:
            throw MIDIMessageError.invalidValue
        }
    }
}

public enum MIDITimeCodeFrameRate: UInt8 {
    case r24 = 0x00
    case r25 = 0x01
    case r29 = 0x02
    case r30 = 0x03
}

extension MIDITimeCodeQuarterFrameMessage {
    public init(_ quarterFrame: MIDITimeCodeQuarterFrameData) throws {
        switch quarterFrame {
        case .frameLsb(let value), .secondLsb(let value), .minuteLsb(let value), .hourLsb(let value):
            guard value < 0x10 else { throw MIDIMessageError.invalidValue }
        case .frameMsb(let value):
            guard value < 0x02 else { throw MIDIMessageError.invalidValue }
        case .secondMsb(let value), .minuteMsb(let value):
            guard value < 0x04 else { throw MIDIMessageError.invalidValue }
        case .hourMsb(let hour, _):
            guard hour < 0x02 else { throw MIDIMessageError.invalidValue }
        }
        self.init(bytes: [0xF1, quarterFrame.byteValue])
    }
}

struct MIDISongPositionPointerMessage: MIDISystemCommonMessage {
    var type: MIDIMessageType { .songPositionPointer }
    let bytes: [UInt8]
    
    public var lsb: UInt8 { bytes[1] }
    public var msb: UInt8 { bytes[2] }
    public var value: UInt16 { UInt16(msb) << 7 + UInt16(lsb) }
}

extension MIDISongPositionPointerMessage {
    public init(value: UInt16) throws {
        try validate(highResultionValueByte: value)
        let mostSignificant7Bits = UInt8(value >> 7)
        let leastSignificant8Bits = UInt8(value & 127)
        self.bytes = [0xF2, leastSignificant8Bits, mostSignificant7Bits]
    }
}

struct MIDISongSelectMessage: MIDISystemCommonMessage {
    var type: MIDIMessageType { .songSelect }
    let bytes: [UInt8]
    
    public var song: UInt8 { bytes[1] }
}

extension MIDISongSelectMessage {
    public init(song: UInt8) throws {
        try validate(valueByte: song)
        self.bytes = [0xF3, song]
    }
}

struct MIDITuneRequestMessage: MIDISystemCommonMessage {
    var type: MIDIMessageType { .tuneRequest }
    let bytes: [UInt8]
}

extension MIDITuneRequestMessage {
    public init() {
        self.bytes = [0xF6]
    }
}
