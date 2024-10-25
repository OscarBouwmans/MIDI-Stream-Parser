
protocol MIDISystemRealTimeMessage: MIDIMessage {}

struct MIDITimingClockMessage: MIDISystemRealTimeMessage {
    let type: MIDIMessageType = .timingClock
    let bytes: [UInt8]
}

extension MIDITimingClockMessage {
    init() {
        self.init(bytes: [MIDIMessageType.timingClock.rawValue])
    }
}

struct MIDIReserved1Message: MIDISystemRealTimeMessage {
    let type: MIDIMessageType = .reserved1
    let bytes: [UInt8] = [MIDIMessageType.reserved1.rawValue]
}

struct MIDIStartMessage: MIDISystemRealTimeMessage {
    let type: MIDIMessageType = .start
    let bytes: [UInt8]
}

extension MIDIStartMessage {
    init() {
        self.init(bytes: [MIDIMessageType.start.rawValue])
    }
}

struct MIDIContinueMessage: MIDISystemRealTimeMessage {
    let type: MIDIMessageType = .continue
    let bytes: [UInt8]
}

extension MIDIContinueMessage {
    init() {
        self.init(bytes: [MIDIMessageType.continue.rawValue])
    }
}

struct MIDIStopMessage: MIDISystemRealTimeMessage {
    let type: MIDIMessageType = .stop
    let bytes: [UInt8]
}

extension MIDIStopMessage {
    init() {
        self.init(bytes: [MIDIMessageType.stop.rawValue])
    }
}

struct MIDIReserved2Message: MIDISystemRealTimeMessage {
    let type: MIDIMessageType = .reserved2
    let bytes: [UInt8] = [MIDIMessageType.reserved2.rawValue]
}

struct MIDIActiveSensingMessage: MIDISystemRealTimeMessage {
    let type: MIDIMessageType = .activeSensing
    let bytes: [UInt8]
}

extension MIDIActiveSensingMessage {
    init() {
        self.init(bytes: [MIDIMessageType.activeSensing.rawValue])
    }
}

struct MIDISystemResetMessage: MIDISystemRealTimeMessage {
    let type: MIDIMessageType = .systemReset
    let bytes: [UInt8]
}

extension MIDISystemResetMessage {
    init() {
        self.bytes = [MIDIMessageType.systemReset.rawValue]
    }
}
