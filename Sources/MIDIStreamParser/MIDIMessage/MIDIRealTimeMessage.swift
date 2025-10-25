
protocol MIDISystemRealTimeMessage: MIDIMessage {}

public struct MIDITimingClockMessage: MIDISystemRealTimeMessage {
    public var type: MIDIMessageType { .timingClock }
    public var bytes: [UInt8] { [MIDIMessageType.timingClock.rawValue] }
}

public struct MIDISystemRealTimeReserved1Message: MIDISystemRealTimeMessage {
    public var type: MIDIMessageType { ._systemRealTimeReserved1 }
    public var bytes: [UInt8] { [MIDIMessageType._systemRealTimeReserved1.rawValue] }
}

public struct MIDIStartMessage: MIDISystemRealTimeMessage {
    public var type: MIDIMessageType { .start }
    public var bytes: [UInt8] { [MIDIMessageType.start.rawValue] }
}

public struct MIDIContinueMessage: MIDISystemRealTimeMessage {
    public var type: MIDIMessageType { .continue }
    public var bytes: [UInt8] { [MIDIMessageType.continue.rawValue] }
}

public struct MIDIStopMessage: MIDISystemRealTimeMessage {
    public var type: MIDIMessageType { .stop }
    public var bytes: [UInt8] { [MIDIMessageType.stop.rawValue] }
}

public struct MIDISystemRealTimeReserved2Message: MIDISystemRealTimeMessage {
    public var type: MIDIMessageType { ._systemRealTimeReserved2 }
    public var bytes: [UInt8] { [MIDIMessageType._systemRealTimeReserved2.rawValue] }
}

public struct MIDIActiveSensingMessage: MIDISystemRealTimeMessage {
    public var type: MIDIMessageType { .activeSensing }
    public var bytes: [UInt8] { [MIDIMessageType.activeSensing.rawValue] }
}

public struct MIDISystemResetMessage: MIDISystemRealTimeMessage {
    public var type: MIDIMessageType { .systemReset }
    public var bytes: [UInt8] { [MIDIMessageType.systemReset.rawValue] }
}
