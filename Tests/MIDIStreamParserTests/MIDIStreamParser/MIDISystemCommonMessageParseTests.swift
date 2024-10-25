import Testing
@testable import MIDIStreamParser

@Test func testParsingMIDISystemCommonMessages() async throws {
    let parser = MIDIStreamParser()
    let delegate = TestDelegate()
    await parser.setDelegate(delegate)
    
    // Push all messages at once
    await parser.push(
        [UInt8].init(([63, 0, 1, 2, 3, 4, 5, 218])) + // << nonsense
        (try! MIDITimeCodeQuarterFrameMessage(.frameLsb(lsb: 5)).bytes) +
        [UInt8].init(([160, 161, 162, 163, 164, 165, 166, 167])) + // << nonsense
        (try! MIDITimeCodeQuarterFrameMessage(.secondMsb(msb: 3)).bytes) +
        (try! MIDISongPositionPointerMessage(value: 8192).bytes) +
        (try! MIDISongSelectMessage(song: 127).bytes) +
        (MIDITuneRequestMessage().bytes) +
        (try! MIDITimeCodeQuarterFrameMessage(.hourMsb(msb: 1, rate: .r30)).bytes) +
        (MIDISystemCommonReserved1Message().bytes) +
        (MIDISystemCommonReserved2Message().bytes)
    )
    
    // Evaluate all parsed messages
    let messages = await delegate.receivedMessages
    #expect(messages.count == 8)
    
    // Test Time Code Quarter Frame (Frame LSB)
    #expect(messages[0] is MIDITimeCodeQuarterFrameMessage)
    if let tcqf = messages[0] as? MIDITimeCodeQuarterFrameMessage {
        #expect(tcqf.value == .frameLsb(lsb: 5))
    }
    
    // Test Time Code Quarter Frame (Second MSB)
    #expect(messages[1] is MIDITimeCodeQuarterFrameMessage)
    if let tcqf = messages[1] as? MIDITimeCodeQuarterFrameMessage {
        #expect(tcqf.value == .secondMsb(msb: 3))
    }
    
    // Test Song Position Pointer
    #expect(messages[2] is MIDISongPositionPointerMessage)
    if let spp = messages[2] as? MIDISongPositionPointerMessage {
        #expect(spp.value == 8192)
        #expect(spp.lsb == 0)
        #expect(spp.msb == 64)
    }
    
    // Test Song Select
    #expect(messages[3] is MIDISongSelectMessage)
    if let ss = messages[3] as? MIDISongSelectMessage {
        #expect(ss.song == 127)
    }
    
    // Test Tune Request
    #expect(messages[4] is MIDITuneRequestMessage)
    
    // Test Time Code Quarter Frame (Hour MSB with frame rate)
    #expect(messages[5] is MIDITimeCodeQuarterFrameMessage)
    if let tcqf = messages[5] as? MIDITimeCodeQuarterFrameMessage {
        #expect(tcqf.value == .hourMsb(msb: 1, rate: .r30))
    }
    
    #expect(messages[6] is MIDISystemCommonReserved1Message)
    #expect(messages[7] is MIDISystemCommonReserved2Message)
}
