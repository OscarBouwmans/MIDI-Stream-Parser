import Testing
@testable import MIDIStreamParser

@Test func testParsingMIDIRunningStatus() async throws {
    let parser = MIDIStreamParser()
    
    // Test running status with Note On messages, interrupted by System Real-Time
    parser.push([
        0x90, 0x3C, 0x7F,  // Note On, channel 1, note 60, velocity 127
        0x3E, 0x50,        // Running status: Note On, channel 1, note 62, velocity 80
        0xF8,              // System Real-Time: Timing Clock (shouldn't cancel running status)
        0x40, 0x40,        // Running status: Note On, channel 1, note 64, velocity 64
    ])
    
    // Test running status with System Common message (should break running status)
    parser.push([
        0x80, 0x3C, 0x00,  // Note Off, channel 1, note 60, velocity 0
        0x3E, 0x00,        // Running status: Note Off, channel 1, note 62, velocity 0
        0xF2, 0x00, 0x10,  // System Common: Song Position Pointer (cancels running status)
        0x3E, 0x00,        // IGNORED: running status should be invalidated
        0x80, 0x40, 0x00,  // Need to resend status: Note Off, channel 1, note 64, velocity 0
    ])
    
    // Test running status with Control Change messages and System Exclusive
    parser.push([
        0xB0, 0x07, 0x7F,  // Control Change, channel 1, controller 7 (volume), value 127
        0x0A, 0x40,        // Running status: Control Change, channel 1, controller 10 (pan), value 64
        0xF0, 0x43, 0x12, 0x00, 0xF7,  // System Exclusive message (cancels running status)
        0x0A, 0x20,        // IGNORED: running status should be invalidated
        0xB0, 0x0B, 0x00,  // Need to resend status: Control Change, channel 1, controller 11, value 0
        0x0C, 0x20         // Running status: Control Change, channel 1, controller 12, value 32
    ])
    
    // Evaluate all parsed messages
    let messages: [MIDIMessage] = parser.next()
    #expect(messages.count == 13)
    
    #expect(messages[0] is MIDINoteOnMessage)
    #expect(messages[1] is MIDINoteOnMessage)
    #expect(messages[2] is MIDITimingClockMessage)
    #expect(messages[3] is MIDINoteOnMessage)
    
    #expect(messages[4] is MIDINoteOffMessage)
    #expect(messages[5] is MIDINoteOffMessage)
    #expect(messages[6] is MIDISongPositionPointerMessage)
    #expect(messages[7] is MIDINoteOffMessage)
    
    #expect(messages[8] is MIDIControlChangeMessage)
    #expect(messages[9] is MIDIControlChangeMessage)
    #expect(messages[10] is MIDISystemExclusiveMessage)
    #expect(messages[11] is MIDIControlChangeMessage)
    #expect(messages[12] is MIDIControlChangeMessage)
}
