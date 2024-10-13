import Testing
@testable import MIDIStreamParser

@Test func testParsingMIDIChannelVoiceMessages() async throws {
    let parser = MIDIStreamParser()
    let delegate = TestDelegate()
    await parser.setDelegate(delegate)
    
    // Push all messages at once
    await parser.push([
        0x90, 0x3C, 0x7F,  // Note On, channel 1, note 60 (middle C), velocity 127
        0x80, 0x3C, 0x00,  // Note Off, channel 1, note 60, velocity 0
        0xA2, 0x48, 0x40,  // Poly Key Pressure, channel 3, note 72, pressure 64
        0xB5, 0x07, 0x7F,  // Control Change, channel 6, controller 7 (volume), value 127
        0xC8, 0x01,        // Program Change, channel 9, program 1
        0xDF, 0x50,        // Channel Pressure, channel 16, pressure 80
        0xE0, 0x00, 0x40,  // Pitch Bend, channel 1, value 8192 (no bend)
        0x90, 0x3C, 0x7F,  // Note On, channel 1, note 60 (middle C), velocity 127
        0x80, 0x3C, 0x00   // Note Off, channel 1, note 60, velocity 0
    ])
    
    // Evaluate all parsed messages
    let messages = await delegate.receivedMessages
    #expect(messages.count == 9)
    
    // Test Note On
    #expect(messages[0] is MIDINoteOnMessage)
    if let noteOn = messages[0] as? MIDINoteOnMessage {
        #expect(noteOn.channel == 0)
        #expect(noteOn.note == 60)
        #expect(noteOn.velocity == 127)
    }
    
    // Test Note Off
    #expect(messages[1] is MIDINoteOffMessage)
    if let noteOff = messages[1] as? MIDINoteOffMessage {
        #expect(noteOff.channel == 0)
        #expect(noteOff.note == 60)
        #expect(noteOff.velocity == 0)
    }
    
    // Test Polyphonic Key Pressure
    #expect(messages[2] is MIDIPolyphonicKeyPressureMessage)
    if let polyPressure = messages[2] as? MIDIPolyphonicKeyPressureMessage {
        #expect(polyPressure.channel == 2)
        #expect(polyPressure.note == 72)
        #expect(polyPressure.pressure == 64)
    }
    
    // Test Control Change
    #expect(messages[3] is MIDIControlChangeMessage)
    if let controlChange = messages[3] as? MIDIControlChangeMessage {
        #expect(controlChange.channel == 5)
        #expect(controlChange.controller == 7)
        #expect(controlChange.value == 127)
    }
    
    // Test Program Change
    #expect(messages[4] is MIDIProgramChangeMessage)
    if let programChange = messages[4] as? MIDIProgramChangeMessage {
        #expect(programChange.channel == 8)
        #expect(programChange.program == 1)
    }
    
    // Test Channel Pressure
    #expect(messages[5] is MIDIChannelPressureMessage)
    if let channelPressure = messages[5] as? MIDIChannelPressureMessage {
        #expect(channelPressure.channel == 15)
        #expect(channelPressure.pressure == 80)
    }
    
    // Test Pitch Bend
    #expect(messages[6] is MIDIPitchBendMessage)
    if let pitchBend = messages[6] as? MIDIPitchBendMessage {
        #expect(pitchBend.channel == 0)
        #expect(pitchBend.value == 8192)
    }
    
    // Test parsing multiple messages in one push
    #expect(messages[7] is MIDINoteOnMessage)
    #expect(messages[8] is MIDINoteOffMessage)
}
