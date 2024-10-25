import Testing
@testable import MIDIStreamParser

@Test func midiTimingClockMessage() async throws {
    let msg = MIDITimingClockMessage()
    #expect(msg.type == .timingClock)
    #expect(msg.bytes.count == 1)
    #expect(msg.bytes[0] == 0xF8)
}

@Test func midiSystemRealTimeReserved1Message() async throws {
    let msg = MIDISystemRealTimeReserved1Message()
    #expect(msg.type == ._systemRealTimeReserved1)
    #expect(msg.bytes.count == 1)
    #expect(msg.bytes[0] == 0xF9)
}

@Test func midiStartMessage() async throws {
    let msg = MIDIStartMessage()
    #expect(msg.type == .start)
    #expect(msg.bytes.count == 1)
    #expect(msg.bytes[0] == 0xFA)
}

@Test func midiContinueMessage() async throws {
    let msg = MIDIContinueMessage()
    #expect(msg.type == .continue)
    #expect(msg.bytes.count == 1)
    #expect(msg.bytes[0] == 0xFB)
}

@Test func midiStopMessage() async throws {
    let msg = MIDIStopMessage()
    #expect(msg.type == .stop)
    #expect(msg.bytes.count == 1)
    #expect(msg.bytes[0] == 0xFC)
}

@Test func midiSystemRealTimeReserved2Message() async throws {
    let msg = MIDISystemRealTimeReserved2Message()
    #expect(msg.type == ._systemRealTimeReserved2)
    #expect(msg.bytes.count == 1)
    #expect(msg.bytes[0] == 0xFD)
}

@Test func midiActiveSensingMessage() async throws {
    let msg = MIDIActiveSensingMessage()
    #expect(msg.type == .activeSensing)
    #expect(msg.bytes.count == 1)
    #expect(msg.bytes[0] == 0xFE)
}

@Test func midiSystemResetMessage() async throws {
    let msg = MIDISystemResetMessage()
    #expect(msg.type == .systemReset)
    #expect(msg.bytes.count == 1)
    #expect(msg.bytes[0] == 0xFF)
}
