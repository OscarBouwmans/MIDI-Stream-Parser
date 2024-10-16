
import Testing
@testable import MIDIStreamParser

@Test func midiNoteOffMessage() async throws {
    let msg = try? MIDINoteOffMessage(channel: 7, note: 60, velocity: 80)
    #expect(msg?.type == .noteOff)
    #expect(msg?.bytes.count == 3)
    #expect(msg?.bytes[0] == 135)
    #expect(msg?.bytes[1] == 60)
    #expect(msg?.bytes[2] == 80)
    #expect(msg?.channel == 7)
    #expect(msg?.note == 60)
    #expect(msg?.velocity == 80)
    
    #expect(throws: MIDIMessageError.invalidChannelNumber) {
        try MIDINoteOffMessage(channel: 16, note: 60, velocity: 80)
    }
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDINoteOffMessage(channel: 7, note: 128, velocity: 80)
    }
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDINoteOffMessage(channel: 7, note: 60, velocity: 128)
    }
}

@Test func midiNoteOnMessage() async throws {
    let msg = try? MIDINoteOnMessage(channel: 7, note: 60, velocity: 80)
    #expect(msg?.type == .noteOn)
    #expect(msg?.bytes.count == 3)
    #expect(msg?.bytes[0] == 151)
    #expect(msg?.bytes[1] == 60)
    #expect(msg?.bytes[2] == 80)
    #expect(msg?.channel == 7)
    #expect(msg?.note == 60)
    #expect(msg?.velocity == 80)
    
    #expect(throws: MIDIMessageError.invalidChannelNumber) {
        try MIDINoteOnMessage(channel: 16, note: 60, velocity: 80)
    }
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDINoteOnMessage(channel: 7, note: 128, velocity: 80)
    }
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDINoteOnMessage(channel: 7, note: 60, velocity: 128)
    }
}

@Test func midiPolyphonicKeyPressureMessage() async throws {
    let msg = try? MIDIPolyphonicKeyPressureMessage(channel: 7, note: 60, pressure: 80)
    #expect(msg?.type == .polyphonicKeyPressure)
    #expect(msg?.bytes.count == 3)
    #expect(msg?.bytes[0] == 167)
    #expect(msg?.bytes[1] == 60)
    #expect(msg?.bytes[2] == 80)
    #expect(msg?.channel == 7)
    #expect(msg?.note == 60)
    #expect(msg?.pressure == 80)
    
    #expect(throws: MIDIMessageError.invalidChannelNumber) {
        try MIDIPolyphonicKeyPressureMessage(channel: 16, note: 60, pressure: 80)
    }
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDIPolyphonicKeyPressureMessage(channel: 7, note: 128, pressure: 80)
    }
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDIPolyphonicKeyPressureMessage(channel: 7, note: 60, pressure: 128)
    }
}

@Test func midiControlChangeMessage() async throws {
    let msg = try? MIDIControlChangeMessage(channel: 7, controller: 64, value: 127)
    #expect(msg?.type == .controlChange)
    #expect(msg?.bytes.count == 3)
    #expect(msg?.bytes[0] == 183)
    #expect(msg?.bytes[1] == 64)
    #expect(msg?.bytes[2] == 127)
    #expect(msg?.channel == 7)
    #expect(msg?.controller == 64)
    #expect(msg?.value == 127)
    
    #expect(throws: MIDIMessageError.invalidChannelNumber) {
        try MIDIControlChangeMessage(channel: 16, controller: 64, value: 127)
    }
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDIControlChangeMessage(channel: 7, controller: 128, value: 127)
    }
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDIControlChangeMessage(channel: 7, controller: 64, value: 128)
    }
}

@Test func midiProgramChangeMessage() async throws {
    let msg = try? MIDIProgramChangeMessage(channel: 7, program: 64)
    #expect(msg?.type == .programChange)
    #expect(msg?.bytes.count == 2)
    #expect(msg?.bytes[0] == 199)
    #expect(msg?.bytes[1] == 64)
    #expect(msg?.channel == 7)
    #expect(msg?.program == 64)
    
    #expect(throws: MIDIMessageError.invalidChannelNumber) {
        try MIDIProgramChangeMessage(channel: 16, program: 64)
    }
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDIProgramChangeMessage(channel: 7, program: 128)
    }
}

@Test func midiChannelPressureMessage() async throws {
    let msg = try? MIDIChannelPressureMessage(channel: 7, pressure: 100)
    #expect(msg?.type == .channelPressure)
    #expect(msg?.bytes.count == 2)
    #expect(msg?.bytes[0] == 215)
    #expect(msg?.bytes[1] == 100)
    #expect(msg?.channel == 7)
    #expect(msg?.pressure == 100)
    
    #expect(throws: MIDIMessageError.invalidChannelNumber) {
        try MIDIChannelPressureMessage(channel: 16, pressure: 100)
    }
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDIChannelPressureMessage(channel: 7, pressure: 128)
    }
}

@Test func midiPitchBendMessage() async throws {
    let msg = try? MIDIPitchBendMessage(channel: 7, value: 8192)
    #expect(msg?.type == .pitchBend)
    #expect(msg?.bytes.count == 3)
    #expect(msg?.bytes[0] == 231)
    #expect(msg?.bytes[1] == 0)
    #expect(msg?.bytes[2] == 64)
    #expect(msg?.channel == 7)
    #expect(msg?.value == 8192)
    
    #expect(throws: MIDIMessageError.invalidChannelNumber) {
        try MIDIPitchBendMessage(channel: 16, value: 8192)
    }
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDIPitchBendMessage(channel: 7, value: 16384)
    }
}
