import Testing
@testable import MIDIStreamParser

actor TestDelegate: MIDIStreamParserDelegate {
    var receivedMessages: [any MIDIMessage] = []
    
    func parser(_: MIDIStreamParser, didParse message: any MIDIMessage) {
        self.receivedMessages.append(message)
    }
}

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
}
