import Testing
@testable import MIDIStreamParser

@Test func midiTimeCodeQuarterFrameMessage() async throws {
    testRange(0x00, 0x0F) { lsb in .frameLsb(lsb: lsb) }
    testRange(0x00, 0x01) { msb in .frameMsb(msb: msb) }
    testRange(0x00, 0x0F) { lsb in .secondLsb(lsb: lsb) }
    testRange(0x00, 0x03) { msb in .secondMsb(msb: msb) }
    testRange(0x00, 0x0F) { lsb in .minuteLsb(lsb: lsb) }
    testRange(0x00, 0x03) { msb in .minuteMsb(msb: msb) }
    testRange(0x00, 0x0F) { lsb in .hourLsb(lsb: lsb) }
    for rate in [MIDITimeCodeFrameRate].init([.r24, .r25, .r29, .r30]) {
        testRange(0x00, 0x01) { msb in .hourMsb(msb: msb, rate: rate) }
    }
    
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDITimeCodeQuarterFrameMessage(.frameLsb(lsb: 0x10))
    }
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDITimeCodeQuarterFrameMessage(.frameMsb(msb: 0x02))
    }
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDITimeCodeQuarterFrameMessage(.secondLsb(lsb: 0x10))
    }
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDITimeCodeQuarterFrameMessage(.secondMsb(msb: 0x04))
    }
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDITimeCodeQuarterFrameMessage(.minuteLsb(lsb: 0x10))
    }
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDITimeCodeQuarterFrameMessage(.minuteMsb(msb: 0x04))
    }
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDITimeCodeQuarterFrameMessage(.hourLsb(lsb: 0x10))
    }
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDITimeCodeQuarterFrameMessage(.hourMsb(msb: 0x02, rate: .r24))
    }
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDITimeCodeQuarterFrameMessage(.frameLsb(lsb: 0x80))
    }
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDITimeCodeQuarterFrameMessage(.hourMsb(msb: 0x02, rate: .r24))
    }
    
    func testRange(_ min: UInt8, _ max: UInt8, _ data: (UInt8) -> MIDITimeCodeQuarterFrameData) {
        for bytes in min...max {
            let value = data(bytes)
            let msg = try? MIDITimeCodeQuarterFrameMessage(value)
            #expect(msg?.bytes.count == 2)
            #expect(msg?.bytes[0] == 0xF1)
            #expect(msg?.bytes[1] == value.byteValue)
            #expect(msg?.value == value)
        }
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
    let msg = try? MIDISongSelectMessage(song: 64)
    #expect(msg?.bytes.count == 2)
    #expect(msg?.bytes[0] == 0xF3)
    #expect(msg?.bytes[1] == 64)
    #expect(msg?.song == 64)
    
    let msgMax = try? MIDISongSelectMessage(song: 127)
    #expect(msgMax?.bytes[1] == 127)
    
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDISongSelectMessage(song: 128)
    }
}

@Test func midiTuneRequestMessage() async throws {
    let msg = MIDITuneRequestMessage()
    #expect(msg.bytes.count == 1)
    #expect(msg.bytes[0] == 0xF6)
}
