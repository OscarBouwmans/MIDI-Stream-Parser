import Testing
@testable import MIDIStreamParser

actor TestDelegate: MIDIStreamParserDelegate {
    var receivedMessages: [any MIDIMessage] = []
    
    func parser(_: MIDIStreamParser, didParse message: any MIDIMessage) {
        self.receivedMessages.append(message)
    }
}

@Test func parsingStorm() async throws {
    let parser = MIDIStreamParser()
    let delegate = TestDelegate()
    await parser.setDelegate(delegate)
    
    let numberOfMessages = 100
    
    // Push all messages at once
    await withTaskGroup(of: Void.self) { taskGroup in
        for _ in 1...numberOfMessages {
            taskGroup.addTask {
                await parser.push([0x90, 0x3C, 0x7F])
            }
        }
    }
    
    #expect(await delegate.receivedMessages.count == numberOfMessages)
}
