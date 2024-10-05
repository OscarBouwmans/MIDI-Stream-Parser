
import Foundation

typealias MIDISingleByteParser = (_: UInt8, _: UInt8?) -> MIDIParserResult

protocol MIDIStreamParserDelegate: Sendable {
    func parser(_: MIDIStreamParser, didParse message: any MIDIMessage) async
}

actor MIDIStreamParser {
    private var currentParser: MIDISingleByteParser
    private var currentRunningStatus: UInt8?
    
    private var parsedMessageQueue: [any MIDIMessage] = [];
    private var isFlushingQueue: Bool = false
    private var currentFlush: Task<Void, Never>?
    
    public var delegate: MIDIStreamParserDelegate?
    
    init() {
        self.currentParser = MIDIStreamParser.statusByteParser()
    }
    
    func setDelegate(_ delegate: MIDIStreamParserDelegate) {
        self.delegate = delegate
    }
    
    func push(_ bytes: [UInt8]) async {
        for byte in bytes {
            let result = self.currentParser(byte, currentRunningStatus)
            if let message = result.message {
                if (MIDIStreamParser.isValidRunningStatusByte(byte: message.bytes.first!)) {
                    currentRunningStatus = message.bytes.first
                } else {
                    currentRunningStatus = nil
                }
                parsedMessageQueue.append(message)
            }
            self.currentParser = result.nextParser
        }
        return await flush().value
    }
    
    private func flush() -> Task<Void, Never> {
        if let currentFlush {
            return currentFlush
        }
        
        currentFlush = Task {
            while parsedMessageQueue.count > 0 {
                let message = parsedMessageQueue.removeFirst()
                await delegate?.parser(self, didParse: message)
            }
            currentFlush = nil
        }
        
        return currentFlush!
    }
    
    static func statusByteParser() -> MIDISingleByteParser {
        return { (incomingByte, currentRunningStatusByte) in
            if incomingByte < 128 {
                guard let runningStatusByte = currentRunningStatusByte else {
                    return MIDIParserResult.None
                }
                let nextParser = selectNextParser(statusByte: runningStatusByte).nextParser
                return nextParser(incomingByte, currentRunningStatusByte)
            }
            
            return selectNextParser(statusByte: incomingByte)
        }
    }
    
    private static func isValidRunningStatusByte(byte: UInt8) -> Bool {
        guard byte > 127 else {
            return false
        }
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
                return MIDIParserResult(message: MIDISongSelect(bytes: [statusByte, song]))
            }
        case MIDIMessageType.tuneRequest.rawValue:
            return MIDIParserResult(message: MIDITuneRequest(bytes: [statusByte]))
        case MIDIMessageType.endOfExclusive.rawValue,
             MIDIMessageType.timingClock.rawValue,
             MIDIMessageType.start.rawValue,
             MIDIMessageType.continue.rawValue,
             MIDIMessageType.stop.rawValue,
             MIDIMessageType.activeSensing.rawValue,
             MIDIMessageType.systemReset.rawValue:
            return MIDIParserResult.None
        default:
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
    
    static var None: MIDIParserResult {
        get {
            return MIDIParserResult(nextParser: MIDIStreamParser.statusByteParser())
        }
    }
}
