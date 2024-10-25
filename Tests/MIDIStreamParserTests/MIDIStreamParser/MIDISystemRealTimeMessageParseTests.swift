import Testing
@testable import MIDIStreamParser

@Test func testParsingMIDISystemRealTimeMessages() async throws {
    let parser = MIDIStreamParser()
    let delegate = TestDelegate()
    await parser.setDelegate(delegate)
    
    // Test parsing real-time messages mixed with other message types
    await parser.push([
        0xF8,                      // Timing Clock
        0x90, 0x3C, 0x7F,         // Note On, channel 1, note 60, velocity 127
        0xFA,                      // Start
        0xF8,                      // Timing Clock
        0x80, 0x3C, 0x00,         // Note Off, channel 1, note 60, velocity 0
        0xFB,                      // Continue
        0xF8,                      // Timing Clock
        0xFC,                      // Stop
        0xF8,                      // Timing Clock
        0xFE,                      // Active Sensing
        0xF8,                      // Timing Clock
        0xFF,                      // System Reset
        0xF8                       // Timing Clock
    ])
    
    // Evaluate all parsed messages
    let messages = await delegate.receivedMessages
    #expect(messages.count == 13)
    
    // Test the sequence of messages
    #expect(messages[0] is MIDITimingClockMessage)
    #expect(messages[1] is MIDINoteOnMessage)
    #expect(messages[2] is MIDIStartMessage)
    #expect(messages[3] is MIDITimingClockMessage)
    #expect(messages[4] is MIDINoteOffMessage)
    #expect(messages[5] is MIDIContinueMessage)
    #expect(messages[6] is MIDITimingClockMessage)
    #expect(messages[7] is MIDIStopMessage)
    #expect(messages[8] is MIDITimingClockMessage)
    #expect(messages[9] is MIDIActiveSensingMessage)
    #expect(messages[10] is MIDITimingClockMessage)
    #expect(messages[11] is MIDIResetMessage)
    #expect(messages[12] is MIDITimingClockMessage)
    
    // Test that Note messages were parsed correctly despite real-time interruption
    if let noteOn = messages[1] as? MIDINoteOnMessage {
        #expect(noteOn.channel == 0)
        #expect(noteOn.note == 60)
        #expect(noteOn.velocity == 127)
    }
    
    if let noteOff = messages[4] as? MIDINoteOffMessage {
        #expect(noteOff.channel == 0)
        #expect(noteOff.note == 60)
        #expect(noteOff.velocity == 0)
    }
}

@Test func testParsingRealTimeWithSysEx() async throws {
    let parser = MIDIStreamParser()
    let delegate = TestDelegate()
    await parser.setDelegate(delegate)
    
    // Test real-time messages interleaved with System Exclusive
    await parser.push([
        0xF0, 0x43,               // Start SysEx
        0xF8,                     // Timing Clock (should be parsed immediately)
        0x12, 0x00,              // Continue SysEx
        0xFA,                     // Start (should be parsed immediately)
        0x7F, 0xF7,              // End SysEx
        0xFB,                     // Continue
        0xFC                      // Stop
    ])
    
    // Evaluate all parsed messages
    let messages = await delegate.receivedMessages
    #expect(messages.count == 5)
    
    #expect(messages[0] is MIDITimingClockMessage)
    #expect(messages[1] is MIDIStartMessage)
    #expect(messages[2] is MIDISystemExclusiveMessage)
    #expect(messages[3] is MIDIContinueMessage)
    #expect(messages[4] is MIDIStopMessage)
    
    // Verify SysEx content
    if let sysEx = messages[2] as? MIDISystemExclusiveMessage {
        #expect(sysEx.payload == [0x43, 0x12, 0x00, 0x7F])
    }
}
