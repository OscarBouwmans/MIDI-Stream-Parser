import Testing
@testable import MIDIStreamParser

@Test func midiSystemExclusiveMessage() async throws {
    let payload: [UInt8] = [0x7E, 0x7F, 0x09, 0x01]
    let msg = try? MIDISystemExclusiveMessage(payload: payload)
    
    #expect(msg?.type == .systemExclusive)
    #expect(msg?.bytes.count == payload.count + 2)
    #expect(msg?.bytes.first == 0xF0)
    #expect(msg?.bytes.last == 0xF7)
    #expect(msg?.payload == payload)
    
    let minMsg = try? MIDISystemExclusiveMessage(payload: [0x00])
    #expect(minMsg?.bytes == [0xF0, 0x00, 0xF7])
    #expect(minMsg?.payload == [0x00])
    
    let largePayload = Array(repeating: UInt8(0x40), count: 1024)
    let largeMsg = try? MIDISystemExclusiveMessage(payload: largePayload)
    #expect(largeMsg?.bytes.count == largePayload.count + 2)
    #expect(largeMsg?.bytes.first == 0xF0)
    #expect(largeMsg?.bytes.last == 0xF7)
    #expect(largeMsg?.payload == largePayload)
    
    #expect(throws: MIDIMessageError.invalidValue) {
        try MIDISystemExclusiveMessage(payload: [])
    }
}
