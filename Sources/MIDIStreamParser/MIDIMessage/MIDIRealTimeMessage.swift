
protocol MIDISystemRealTimeMessage: MIDIMessage {}

public struct MIDITimingClockMessage: MIDISystemRealTimeMessage {
    public let type: MIDIMessageType = .timingClock
    public let bytes: [UInt8] = [MIDIMessageType.timingClock.rawValue]
    public init() {}
}

public struct MIDISystemRealTimeReserved1Message: MIDISystemRealTimeMessage {
    public let type: MIDIMessageType = ._systemRealTimeReserved1
    public let bytes = [MIDIMessageType._systemRealTimeReserved1.rawValue]
    public init() {}
}

public struct MIDIStartMessage: MIDISystemRealTimeMessage {
    public let type: MIDIMessageType = .start
    public let bytes = [MIDIMessageType.start.rawValue]
    public init() {}
}

public struct MIDIContinueMessage: MIDISystemRealTimeMessage {
    public let type: MIDIMessageType = .continue
    public let bytes = [MIDIMessageType.continue.rawValue]
    public init() {}
}

public struct MIDIStopMessage: MIDISystemRealTimeMessage {
    public let type: MIDIMessageType = .stop
    public let bytes = [MIDIMessageType.stop.rawValue]
    public init() {}
}

public struct MIDISystemRealTimeReserved2Message: MIDISystemRealTimeMessage {
    public let type: MIDIMessageType = ._systemRealTimeReserved2
    public let bytes = [MIDIMessageType._systemRealTimeReserved2.rawValue]
    public init() {}
}

public struct MIDIActiveSensingMessage: MIDISystemRealTimeMessage {
    public let type: MIDIMessageType = .activeSensing
    public let bytes = [MIDIMessageType.activeSensing.rawValue]
    public init() {}
}

public struct MIDISystemResetMessage: MIDISystemRealTimeMessage {
    public let type: MIDIMessageType = .systemReset
    public let bytes = [MIDIMessageType.systemReset.rawValue]
    public init() {}
}
