
typealias MIDISingleByteParser = (_: UInt8, _: UInt8?) -> MIDIParserResult

public class MIDIStreamParser {
    private var currentParser: MIDISingleByteParser
    private var currentRunningStatus: UInt8?
    
    private var parsedMessageQueue: [any MIDIMessage] = [];
    
    public init() {
        self.currentParser = MIDIStreamParser.statusByteParser()
    }
    
    public func push(_ bytes: [UInt8]) {
        for byte in bytes {
            if (MIDIStreamParser.doesByteInvalidateRunningStatus(byte: byte)) {
                currentRunningStatus = nil
            }
            
            let result = self.currentParser(byte, currentRunningStatus)
            if let message = result.message {
                if (MIDIStreamParser.isValidRunningStatusByte(byte: message.bytes.first!)) {
                    currentRunningStatus = message.bytes.first
                }
                parsedMessageQueue.append(message)
            }
            self.currentParser = result.nextParser
        }
    }
    
    public var pendingMessageCount: Int {
        return parsedMessageQueue.count
    }
    
    public func next() -> (any MIDIMessage)? {
        guard parsedMessageQueue.count > 0 else { return nil }
        return parsedMessageQueue.removeFirst()
    }
    
    public func next() -> [any MIDIMessage] {
        let messages = parsedMessageQueue
        parsedMessageQueue.removeAll()
        return messages
    }
    
    static func statusByteParser() -> MIDISingleByteParser {
        return { (incomingByte, currentRunningStatusByte) in
            if incomingByte < 128, let runningStatusByte = currentRunningStatusByte {
                let nextParser = selectNextParser(statusByte: runningStatusByte).nextParser
                return nextParser(incomingByte, currentRunningStatusByte)
            }
            return selectNextParser(statusByte: incomingByte)
        }
    }
    
    private static func isValidRunningStatusByte(byte: UInt8) -> Bool {
        switch byte & 0xF0 {
        case MIDIMessageType.noteOff.rawValue,
            MIDIMessageType.noteOn.rawValue,
            MIDIMessageType.polyphonicKeyPressure.rawValue,
            MIDIMessageType.controlChange.rawValue,
            MIDIMessageType.programChange.rawValue,
            MIDIMessageType.channelPressure.rawValue,
            MIDIMessageType.pitchBend.rawValue:
            return true
        default:
            return false
        }
    }
    
    private static let invalidRunningStatusMessageTypes: [MIDIMessageType] = [
        .systemExclusive,
        .timeCodeQuarterFrame,
        .songPositionPointer,
        .songSelect,
        ._systemRealTimeReserved1,
        ._systemRealTimeReserved2,
        .tuneRequest,
        .endOfExclusive,
    ]
    
    private static func doesByteInvalidateRunningStatus(byte: UInt8) -> Bool {
        return invalidRunningStatusMessageTypes.contains(where: { $0.rawValue == byte })
    }
}

extension MIDIStreamParser {
    static func selectNextParser(statusByte: UInt8) -> MIDIParserResult {
        switch statusByte & 0xF0 {
        case MIDIMessageType.noteOff.rawValue:
            return statusNoteOffParser(statusByte: statusByte)
        case MIDIMessageType.noteOn.rawValue:
            return statusNoteOnParser(statusByte: statusByte)
        case MIDIMessageType.polyphonicKeyPressure.rawValue:
            return statusPolyphonicKeyPressureParser(statusByte: statusByte)
        case MIDIMessageType.controlChange.rawValue:
            return statusControlChangeParser(statusByte: statusByte)
        case MIDIMessageType.programChange.rawValue:
            return statusProgramChangeParser(statusByte: statusByte)
        case MIDIMessageType.channelPressure.rawValue:
            return statusChannelPressureParser(statusByte: statusByte)
        case MIDIMessageType.pitchBend.rawValue:
            return statusPitchBendParser(statusByte: statusByte)
        default:
            return selectNextNonChannelVoiceParser(statusByte: statusByte)
        }
    }
    
    static private func selectNextNonChannelVoiceParser(statusByte: UInt8) -> MIDIParserResult {
        switch statusByte {
        case MIDIMessageType.systemExclusive.rawValue:
            return statusSystemExclusiveParser(statusByte: statusByte)
        case MIDIMessageType.timeCodeQuarterFrame.rawValue:
            return valueByteGuard { value, _ in
                return MIDIParserResult(message: MIDITimeCodeQuarterFrameMessage(bytes: [statusByte, value]))
            }
        case MIDIMessageType.songPositionPointer.rawValue:
            return valueByteGuard { lsb, _ in
                return valueByteGuard { msb, _ in
                    return MIDIParserResult(message: MIDISongPositionPointerMessage(bytes: [statusByte, lsb, msb]))
                }
            }
        case MIDIMessageType.songSelect.rawValue:
            return valueByteGuard { song, _ in
                return MIDIParserResult(message: MIDISongSelectMessage(bytes: [statusByte, song]))
            }
        case MIDIMessageType._systemCommonReserved1.rawValue:
            return MIDIParserResult(message: MIDISystemCommonReserved1Message())
        case MIDIMessageType._systemCommonReserved2.rawValue:
            return MIDIParserResult(message: MIDISystemCommonReserved2Message())
        case MIDIMessageType.tuneRequest.rawValue:
            return MIDIParserResult(message: MIDITuneRequestMessage(bytes: [statusByte]))
        case MIDIMessageType.endOfExclusive.rawValue:
            return MIDIParserResult.None
        case MIDIMessageType.timingClock.rawValue:
            return MIDIParserResult(message: MIDITimingClockMessage())
        case MIDIMessageType._systemRealTimeReserved1.rawValue:
            return MIDIParserResult(message: MIDISystemRealTimeReserved1Message())
        case MIDIMessageType.start.rawValue:
            return MIDIParserResult(message: MIDIStartMessage())
        case MIDIMessageType.continue.rawValue:
            return MIDIParserResult(message: MIDIContinueMessage())
        case MIDIMessageType.stop.rawValue:
            return MIDIParserResult(message: MIDIStopMessage())
        case MIDIMessageType._systemRealTimeReserved2.rawValue:
            return MIDIParserResult(message: MIDISystemRealTimeReserved2Message())
        case MIDIMessageType.activeSensing.rawValue:
            return MIDIParserResult(message: MIDIActiveSensingMessage() )
         case MIDIMessageType.systemReset.rawValue:
            return MIDIParserResult(message: MIDISystemResetMessage())
        default:
            // we end up here, if a value byte is provided without status byte (and no running status is available)
            return MIDIParserResult.None
        }
    }
    
    static func valueByteGuard(_ subParser: @escaping MIDISingleByteParser) -> MIDIParserResult {
        return MIDIParserResult { (byte, runningStatus) in
            guard byte < 128 else {
                return MIDIStreamParser.statusByteParser()(byte, nil)
            }
            return subParser(byte, runningStatus)
        }
    }
}

struct MIDIParserResult {
    let nextParser: MIDISingleByteParser
    let message: MIDIMessage?
    
    init(message: MIDIMessage? = nil) {
        self.nextParser = MIDIStreamParser.statusByteParser()
        self.message = message
    }
    
    init(nextParser: @escaping MIDISingleByteParser) {
        self.nextParser = nextParser;
        self.message = nil;
    }
    
    init(interrupting message: MIDISystemRealTimeMessage, nextParser: @escaping MIDISingleByteParser) {
        self.nextParser = nextParser;
        self.message = message
    }
    
    static var None: MIDIParserResult {
        get {
            return MIDIParserResult(nextParser: MIDIStreamParser.statusByteParser())
        }
    }
}
