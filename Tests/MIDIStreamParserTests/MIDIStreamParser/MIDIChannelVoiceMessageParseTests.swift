import Testing
@testable import MIDIStreamParser

actor TestDelegate: MIDIStreamParserDelegate {
    var receivedMessages: [any MIDIMessage] = []
    
    func parser(_: MIDIStreamParser, didParse message: any MIDIMessage) {
        self.receivedMessages.append(message)
    }
}

@Test func testParsingMIDIChannelVoiceMessages() async throws {
    let parser = MIDIStreamParser()
    let delegate = TestDelegate()
    await parser.setDelegate(delegate)
    
    // Test Note On
    await parser.push([0x90, 0x3C, 0x7F])  // Note On, channel 1, note 60 (middle C), velocity 127
    #expect((await delegate.receivedMessages).count == 1)
    #expect((await delegate.receivedMessages)[0] is MIDINoteOnMessage)
    if let noteOn = (await delegate.receivedMessages)[0] as? MIDINoteOnMessage {
        #expect(noteOn.channel == 0)
        #expect(noteOn.note == 60)
        #expect(noteOn.velocity == 127)
    }
    
    // Test Note Off
    await parser.push([0x80, 0x3C, 0x00])  // Note Off, channel 1, note 60, velocity 0
    #expect((await delegate.receivedMessages).count == 2)
    #expect((await delegate.receivedMessages)[1] is MIDINoteOffMessage)
    if let noteOff = (await delegate.receivedMessages)[1] as? MIDINoteOffMessage {
        #expect(noteOff.channel == 0)
        #expect(noteOff.note == 60)
        #expect(noteOff.velocity == 0)
    }
    
    // Test Polyphonic Key Pressure
    await parser.push([0xA2, 0x48, 0x40])  // Poly Key Pressure, channel 3, note 72, pressure 64
    #expect((await delegate.receivedMessages).count == 3)
    #expect((await delegate.receivedMessages)[2] is MIDIPolyphonicKeyPressureMessage)
    if let polyPressure = (await delegate.receivedMessages)[2] as? MIDIPolyphonicKeyPressureMessage {
        #expect(polyPressure.channel == 2)
        #expect(polyPressure.note == 72)
        #expect(polyPressure.pressure == 64)
    }
    
    // Test Control Change
    await parser.push([0xB5, 0x07, 0x7F])  // Control Change, channel 6, controller 7 (volume), value 127
    #expect((await delegate.receivedMessages).count == 4)
    #expect((await delegate.receivedMessages)[3] is MIDIControlChangeMessage)
    if let controlChange = (await delegate.receivedMessages)[3] as? MIDIControlChangeMessage {
        #expect(controlChange.channel == 5)
        #expect(controlChange.controller == 7)
        #expect(controlChange.value == 127)
    }
    
    // Test Program Change
    await parser.push([0xC8, 0x01])  // Program Change, channel 9, program 1
    #expect((await delegate.receivedMessages).count == 5)
    #expect((await delegate.receivedMessages)[4] is MIDIProgramChangeMessage)
    if let programChange = (await delegate.receivedMessages)[4] as? MIDIProgramChangeMessage {
        #expect(programChange.channel == 8)
        #expect(programChange.program == 1)
    }
    
    // Test Channel Pressure
    await parser.push([0xDF, 0x50])  // Channel Pressure, channel 16, pressure 80
    #expect((await delegate.receivedMessages).count == 6)
    #expect((await delegate.receivedMessages)[5] is MIDIChannelPressureMessage)
    if let channelPressure = (await delegate.receivedMessages)[5] as? MIDIChannelPressureMessage {
        #expect(channelPressure.channel == 15)
        #expect(channelPressure.pressure == 80)
    }
    
    // Test Pitch Bend
    await parser.push([0xE0, 0x00, 0x40])  // Pitch Bend, channel 1, value 8192 (no bend)
    #expect((await delegate.receivedMessages).count == 7)
    #expect((await delegate.receivedMessages)[6] is MIDIPitchBendMessage)
    if let pitchBend = (await delegate.receivedMessages)[6] as? MIDIPitchBendMessage {
        #expect(pitchBend.channel == 0)
        #expect(pitchBend.value == 8192)
    }
    
    // Test parsing multiple messages in one push
    await parser.push([0x90, 0x3C, 0x7F, 0x80, 0x3C, 0x00])  // Note On followed by Note Off
    #expect((await delegate.receivedMessages).count == 9)
    #expect((await delegate.receivedMessages)[7] is MIDINoteOnMessage)
    #expect((await delegate.receivedMessages)[8] is MIDINoteOffMessage)
}
