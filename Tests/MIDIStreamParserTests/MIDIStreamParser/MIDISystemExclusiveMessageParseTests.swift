import Testing
@testable import MIDIStreamParser

@Test func testParsingSysExMessages() async throws {
    let parser = MIDIStreamParser()
    
    let testMessages: [MIDIMessage] = [
        try! MIDISystemExclusiveMessage(payload: [4, 8, 15, 16, 23, 42]),
        try! MIDISystemExclusiveMessage(payload: Array(0...127)),
        MIDITimingClockMessage(),
        MIDIStartMessage(),
        MIDIContinueMessage(),
        MIDIStopMessage(),
        MIDIActiveSensingMessage(),
        MIDISystemResetMessage(),
        MIDITimingClockMessage(),
        try! MIDISystemExclusiveMessage(payload: [0x41, 0x10, 0x42, 0x12, 0x40, 0x00, 0x7F, 0x00, 0x41]),
    ]
    
    parser.push([]
        + testMessages[0].bytes
        + testMessages[1].bytes
        + [UInt8](testMessages[9].bytes[0...3])
        + testMessages[2].bytes
        + testMessages[3].bytes
        + testMessages[4].bytes
        + [UInt8](testMessages[9].bytes[4...7])
        + testMessages[5].bytes
        + testMessages[6].bytes
        + testMessages[7].bytes
        + testMessages[8].bytes
        + [UInt8](testMessages[9].bytes[7...10])
    )
    
    let messages: [MIDIMessage] = parser.next()
    #expect(messages.count == testMessages.count)
    
    for (index, message) in messages.enumerated() {
        let testMessage = messages[index]
        #expect(message.type == testMessage.type)
        #expect(message.bytes == testMessage.bytes)
    }
}

@Test func testInvalidSysExParsing() async throws {
    let parser = MIDIStreamParser()
    
    let noteOn = try! MIDINoteOnMessage(channel: 0, note: 60, velocity: 127)
    let quarterFrame = try! MIDITimeCodeQuarterFrameMessage(.frameLsb(lsb: 5))
    
    // Push invalid SysEx messages
    parser.push([]
        + [UInt8]([0xF0, 0x41, 0x10, 0x42, 0x12, 0x40]) // Start of SysEx
        + noteOn.bytes                                  // Note On (should invalidate SysEx)
        + [UInt8]([0x00, 0xF7])                         // Continuation and end of SysEx (should be ignored)
        + [UInt8]([0xF0, 0x43, 0x12, 0x00])             // Start of new SysEx
        + quarterFrame.bytes                            // Time Code Quarter Frame (should invalidate SysEx)
        + [UInt8]([0x7D, 0x00, 0xF7])                   // End of SysEx (should be ignored)
    )
    
    // Evaluate parsed messages
    let messages: [MIDIMessage] = parser.next()
    print(messages)
    #expect(messages.count == 2)
    
    // Test Note On message (which invalidated the first SysEx)
    #expect(messages[0] is MIDINoteOnMessage)
    if let noteOn = messages[0] as? MIDINoteOnMessage {
        #expect(noteOn.channel == 0)
        #expect(noteOn.note == 60)
        #expect(noteOn.velocity == 127)
    }
    
    // Test Time Code Quarter Frame message (which invalidated the second SysEx)
    #expect(messages[1] is MIDITimeCodeQuarterFrameMessage)
    if let tcqf = messages[1] as? MIDITimeCodeQuarterFrameMessage {
        #expect(tcqf.value == .frameLsb(lsb: 5))
    }
}

@Test func testHugeSysExParsing() async throws {
    let parser = MIDIStreamParser()
    
    let bigMessage = Array(0...65_536).map({ UInt8($0 % 128) })
    
    let testMessages: [MIDIMessage] = [
        try! MIDINoteOnMessage(channel: 1, note: 2, velocity: 3),
        try! MIDISystemExclusiveMessage(payload: bigMessage),
        try! MIDIControlChangeMessage(channel: 1, controller: 2, value: 3),
    ]
    
    parser.push([]
        + testMessages[0].bytes
        + testMessages[1].bytes
        + testMessages[2].bytes
    )
    
    let messages: [MIDIMessage] = parser.next()
    #expect(messages.count == testMessages.count)
    #expect(messages[1].bytes.count == bigMessage.count + 2)
    
    for (index, message) in messages.enumerated() {
        let testMessage = messages[index]
        #expect(message.type == testMessage.type)
        #expect(message.bytes == testMessage.bytes)
    }
}

@Test func testEmptySysExParsing() async throws {
    let parser = MIDIStreamParser()
    
    parser.push([]
        + (try! MIDIProgramChangeMessage(channel: 7, program: 8)).bytes
        + [0xF0, 0xF7]
        + (try! MIDIControlChangeMessage(channel: 1, controller: 2, value: 3)).bytes
    )
    
    let messages: [MIDIMessage] = parser.next()
    #expect(messages.count == 2)
    #expect(messages[0] is MIDIProgramChangeMessage)
    #expect(messages[1] is MIDIControlChangeMessage)
}
