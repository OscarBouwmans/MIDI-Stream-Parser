import Testing
@testable import MIDIStreamParser

@Test func parsingStorm() async throws {
    let parser = MIDIStreamParser()
    
    let numberOfMessages = 128
    
    for i in 0..<numberOfMessages {
        parser.push([0x90, 0x3C, UInt8(i)])
    }
    
    #expect(parser.pendingMessageCount == numberOfMessages)
    
    var i = 0
    while let message = parser.next() {
        #expect(message.bytes[2] == i)
        i += 1
    }
    #expect(i == numberOfMessages)
}
