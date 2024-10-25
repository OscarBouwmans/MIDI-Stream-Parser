
protocol MIDISystemRealTimeMessage: MIDIMessage {}

struct MIDITimingClockMessage: MIDISystemRealTimeMessage {
    let type: MIDIMessageType = .timingClock
    let bytes: [UInt8] = [MIDIMessageType.timingClock.rawValue]
}

struct MIDISystemRealTimeReserved1Message: MIDISystemRealTimeMessage {
    let type: MIDIMessageType = ._systemRealTimeReserved1
    let bytes = [MIDIMessageType._systemRealTimeReserved1.rawValue]
}

struct MIDIStartMessage: MIDISystemRealTimeMessage {
    let type: MIDIMessageType = .start
    let bytes = [MIDIMessageType.start.rawValue]
}

struct MIDIContinueMessage: MIDISystemRealTimeMessage {
    let type: MIDIMessageType = .continue
    let bytes = [MIDIMessageType.continue.rawValue]
}

struct MIDIStopMessage: MIDISystemRealTimeMessage {
    let type: MIDIMessageType = .stop
    let bytes = [MIDIMessageType.stop.rawValue]
}

struct MIDISystemRealTimeReserved2Message: MIDISystemRealTimeMessage {
    let type: MIDIMessageType = ._systemRealTimeReserved2
    let bytes = [MIDIMessageType._systemRealTimeReserved2.rawValue]
}

struct MIDIActiveSensingMessage: MIDISystemRealTimeMessage {
    let type: MIDIMessageType = .activeSensing
    let bytes = [MIDIMessageType.activeSensing.rawValue]
}

struct MIDISystemResetMessage: MIDISystemRealTimeMessage {
    let type: MIDIMessageType = .systemReset
    let bytes = [MIDIMessageType.systemReset.rawValue]
}
