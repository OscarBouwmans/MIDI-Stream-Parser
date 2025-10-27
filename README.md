# MIDIStreamParser

A MIDI 1.0 message parser written in Swift that converts raw MIDI byte streams into structured MIDI messages.

Note that this library has no integration with CoreMIDI or any other MIDI packages.

MIDI 2.0 support may be added in the future, maybe not.

## Features

- Complete handling of all MIDI 1.0 message types:
  - Channel Voice Messages (Note On/Off, Control Change, etc.)
  - System Common Messages (System Exclusive, Time Code, etc.)
  - System Real-Time Messages (Timing Clock, Start/Stop, etc.)
- Running Status support
- System Exclusive (SysEx) message handling with Real-Time message interleaving
- Zero dependencies
- 100% test coverage

## Installation

Add this package to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/OscarBouwmans/MIDI-Stream-Parser.git", branch: "main")
]
```

## Usage

```swift
import MIDIStreamParser

// Create a parser instance
let parser = MIDIStreamParser()

// Push some MIDI bytes
parser.push([0x90, 0x3C, 0x7F]) // Note On, middle C, velocity 127

print(parser.pendingMessageCount) // 1

// Handle parsed messages
while let message = parser.next() {
    switch message {
    case let noteOn as MIDINoteOnMessage:
        print("Note On - Channel: \(noteOn.channel), Note: \(noteOn.note), Velocity: \(noteOn.velocity)")
    default:
        break
    }
}

// Or get all pending messages at once
let messages: [MIDIMessage] = parser.next()
```

A `push` can include multiple or partial MIDI message bytes, e.g.:

```swift
// pushing the same Note On message 5 times, in chunks:
parser.push([0x90, 0x3C])
parser.push([0x7F])
parser.push([0x90, 0x3C, 0x7F, 0x90])
parser.push([0x3C, 0x7F, 0x90, 0x3C, 0x7F, 0x90])
parser.push([0x3C, 0x7F])

print(parser.pendingMessageCount) // 5
```

## Message Types

The library supports all MIDI message types defined in the MIDI 1.0 specification:

- Channel Voice Messages
  - Note Off
  - Note On
  - Polyphonic Key Pressure
  - Control Change
  - Program Change
  - Channel Pressure
  - Pitch Bend
- System Common Messages
  - System Exclusive
  - Time Code Quarter Frame
  - Song Position Pointer
  - Song Select
  - Tune Request
- System Real-Time Messages
  - Timing Clock
  - Start
  - Continue
  - Stop
  - Active Sensing
  - System Reset

## License

MIT

## Contributing

Bug reports and fixes are welcome. Please feel free to report an Issue with reproduction steps, or submit a Pull Request.
