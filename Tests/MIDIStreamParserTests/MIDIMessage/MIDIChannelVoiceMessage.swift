
import Testing
@testable import MIDIStreamParser

@Test func midiNoteOffMessage() async throws {
    let msg = try? MIDINoteOffMessage(channel: 7, note: 60, velocity: 80)
    #expect(msg?.bytes.count == 3)
    #expect(msg?.bytes[0] == 135)
    #expect(msg?.bytes[1] == 60)
    #expect(msg?.bytes[2] == 80)
    #expect(msg?.channel == 7)
    #expect(msg?.note == 60)
    #expect(msg?.velocity == 80)
    
    do {
        _ = try MIDINoteOffMessage(channel: 16, note: 60, velocity: 80)
    }
    catch (let error) {
        #expect((error as? MIDIMessageError) == .invalidChannelNumber)
    }
    
    do {
        _ = try MIDINoteOffMessage(channel: 7, note: 128, velocity: 80)
    }
    catch (let error) {
        #expect((error as? MIDIMessageError) == .invalidValue)
    }
    
    do {
        _ = try MIDINoteOffMessage(channel: 7, note: 60, velocity: 128)
    }
    catch (let error) {
        #expect((error as? MIDIMessageError) == .invalidValue)
    }
}

@Test func midiNoteOnMessage() async throws {
    let msg = try? MIDINoteOnMessage(channel: 7, note: 60, velocity: 80)
    #expect(msg?.bytes.count == 3)
    #expect(msg?.bytes[0] == 151)
    #expect(msg?.bytes[1] == 60)
    #expect(msg?.bytes[2] == 80)
    #expect(msg?.channel == 7)
    #expect(msg?.note == 60)
    #expect(msg?.velocity == 80)
    
    do {
        _ = try MIDINoteOnMessage(channel: 16, note: 60, velocity: 80)
    }
    catch (let error) {
        #expect((error as? MIDIMessageError) == .invalidChannelNumber)
    }
    
    do {
        _ = try MIDINoteOnMessage(channel: 7, note: 128, velocity: 80)
    }
    catch (let error) {
        #expect((error as? MIDIMessageError) == .invalidValue)
    }
    
    do {
        _ = try MIDINoteOnMessage(channel: 7, note: 60, velocity: 128)
    }
    catch (let error) {
        #expect((error as? MIDIMessageError) == .invalidValue)
    }
}

@Test func midiPolyphonicKeyPressureMessage() async throws {
    let msg = try? MIDIPolyphonicKeyPressureMessage(channel: 7, note: 60, pressure: 80)
    #expect(msg?.bytes.count == 3)
    #expect(msg?.bytes[0] == 167)
    #expect(msg?.bytes[1] == 60)
    #expect(msg?.bytes[2] == 80)
    #expect(msg?.channel == 7)
    #expect(msg?.note == 60)
    #expect(msg?.pressure == 80)
    
    do {
        _ = try MIDIPolyphonicKeyPressureMessage(channel: 16, note: 60, pressure: 80)
    }
    catch (let error) {
        #expect((error as? MIDIMessageError) == .invalidChannelNumber)
    }
    
    do {
        _ = try MIDIPolyphonicKeyPressureMessage(channel: 7, note: 128, pressure: 80)
    }
    catch (let error) {
        #expect((error as? MIDIMessageError) == .invalidValue)
    }
    
    do {
        _ = try MIDIPolyphonicKeyPressureMessage(channel: 7, note: 60, pressure: 128)
    }
    catch (let error) {
        #expect((error as? MIDIMessageError) == .invalidValue)
    }
}

@Test func midiControlChangeMessage() async throws {
    let msg = try? MIDIControlChangeMessage(channel: 7, controller: 64, value: 127)
    #expect(msg?.bytes.count == 3)
    #expect(msg?.bytes[0] == 183)
    #expect(msg?.bytes[1] == 64)
    #expect(msg?.bytes[2] == 127)
    #expect(msg?.channel == 7)
    #expect(msg?.controller == 64)
    #expect(msg?.value == 127)
    
    do {
        _ = try MIDIControlChangeMessage(channel: 16, controller: 64, value: 127)
    }
    catch (let error) {
        #expect((error as? MIDIMessageError) == .invalidChannelNumber)
    }
    
    do {
        _ = try MIDIControlChangeMessage(channel: 7, controller: 128, value: 127)
    }
    catch (let error) {
        #expect((error as? MIDIMessageError) == .invalidValue)
    }
    
    do {
        _ = try MIDIControlChangeMessage(channel: 7, controller: 64, value: 128)
    }
    catch (let error) {
        #expect((error as? MIDIMessageError) == .invalidValue)
    }
}

@Test func midiProgramChangeMessage() async throws {
    let msg = try? MIDIProgramChangeMessage(channel: 7, program: 64)
    #expect(msg?.bytes.count == 2)
    #expect(msg?.bytes[0] == 199)
    #expect(msg?.bytes[1] == 64)
    #expect(msg?.channel == 7)
    #expect(msg?.program == 64)
    
    do {
        _ = try MIDIProgramChangeMessage(channel: 16, program: 64)
    }
    catch (let error) {
        #expect((error as? MIDIMessageError) == .invalidChannelNumber)
    }
    
    do {
        _ = try MIDIProgramChangeMessage(channel: 7, program: 128)
    }
    catch (let error) {
        #expect((error as? MIDIMessageError) == .invalidValue)
    }
}

@Test func midiChannelPressureMessage() async throws {
    let msg = try? MIDIChannelPressureMessage(channel: 7, pressure: 100)
    #expect(msg?.bytes.count == 2)
    #expect(msg?.bytes[0] == 215)
    #expect(msg?.bytes[1] == 100)
    #expect(msg?.channel == 7)
    #expect(msg?.pressure == 100)
    
    do {
        _ = try MIDIChannelPressureMessage(channel: 16, pressure: 100)
    }
    catch (let error) {
        #expect((error as? MIDIMessageError) == .invalidChannelNumber)
    }
    
    do {
        _ = try MIDIChannelPressureMessage(channel: 7, pressure: 128)
    }
    catch (let error) {
        #expect((error as? MIDIMessageError) == .invalidValue)
    }
}

@Test func midiPitchBendMessage() async throws {
    let msg = try? MIDIPitchBendMessage(channel: 7, value: 8192)
    #expect(msg?.bytes.count == 3)
    #expect(msg?.bytes[0] == 231)
    #expect(msg?.bytes[1] == 0)
    #expect(msg?.bytes[2] == 64)
    #expect(msg?.channel == 7)
    #expect(msg?.value == 8192)
    
    do {
        _ = try MIDIPitchBendMessage(channel: 16, value: 8192)
    }
    catch (let error) {
        #expect((error as? MIDIMessageError) == .invalidChannelNumber)
    }
    
    do {
        _ = try MIDIPitchBendMessage(channel: 7, value: 16384)
    }
    catch (let error) {
        #expect((error as? MIDIMessageError) == .invalidValue)
    }
}
