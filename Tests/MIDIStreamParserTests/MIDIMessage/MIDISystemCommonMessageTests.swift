import Testing
@testable import MIDIStreamParser

@Test func midiTimeCodeQuarterFrameMessage() async throws {
    let msgFrameLsb = try? MIDITimeCodeQuarterFrameMessage(.frameLsb(lsb: 0x0F))
    #expect(msgFrameLsb?.bytes.count == 2)
    #expect(msgFrameLsb?.bytes[0] == 0xF1)
    #expect(msgFrameLsb?.bytes[1] == 0x0F)
    #expect(msgFrameLsb?.value == .frameLsb(lsb: 0x0F))
    
    let msgHourMsb = try? MIDITimeCodeQuarterFrameMessage(.hourMsb(msb: 1, rate: .r25))
    #expect(msgHourMsb?.bytes.count == 2)
    #expect(msgHourMsb?.bytes[0] == 0xF1)
    #expect(msgHourMsb?.bytes[1] == 0x75)
    #expect(msgHourMsb?.value == .hourMsb(msb: 1, rate: .r25))
    
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDITimeCodeQuarterFrameMessage(.frameLsb(lsb: 0x80))
    }
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDITimeCodeQuarterFrameMessage(.hourMsb(msb: 2, rate: .r24))
    }
}

@Test func midiSongPositionPointerMessage() async throws {
    let msg = try? MIDISongPositionPointerMessage(value: 8192)
    #expect(msg?.bytes.count == 3)
    #expect(msg?.bytes[0] == 0xF2)
    #expect(msg?.bytes[1] == 0x00)
    #expect(msg?.bytes[2] == 0x40)
    #expect(msg?.lsb == 0x00)
    #expect(msg?.msb == 0x40)
    #expect(msg?.value == 8192)
    
    let msgMax = try? MIDISongPositionPointerMessage(value: 16383)
    #expect(msgMax?.bytes[1] == 0x7F)
    #expect(msgMax?.bytes[2] == 0x7F)
    
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDISongPositionPointerMessage(value: 16384)
    }
}

@Test func midiSongSelectMessage() async throws {
    let msg = try? MIDISongSelect(song: 64)
    #expect(msg?.bytes.count == 2)
    #expect(msg?.bytes[0] == 0xF3)
    #expect(msg?.bytes[1] == 64)
    #expect(msg?.song == 64)
    
    let msgMax = try? MIDISongSelect(song: 127)
    #expect(msgMax?.bytes[1] == 127)
    
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDISongSelect(song: 128)
    }
}

@Test func midiTuneRequestMessage() async throws {
    let msg = MIDITuneRequest()
    #expect(msg.bytes.count == 1)
    #expect(msg.bytes[0] == 0xF6)
}
