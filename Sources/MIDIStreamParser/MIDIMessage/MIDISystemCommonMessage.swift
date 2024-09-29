//
//  MIDISystemCommonMessage.swift
//  MIDIStreamParser
//
//  Created by Oscar Bouwmans on 29/09/2024.
//


protocol MidiSystemCommonMessage: MidiMessage {}

struct MidiTimeCodeQuarterFrameMessage: MidiSystemCommonMessage {
    var type: MidiMessageType { .timeCodeQuarterFrame }
    let bytes: [UInt8]
    
    var partialTimeCodeType: UInt8 { bytes[1] >> 4 }
    var partialTimeCodeValue: UInt8 { bytes[1] & 0x0F }
}

struct MidiSongPositionPointerMessage: MidiSystemCommonMessage {
    var type: MidiMessageType { .songPositionPointer }
    let bytes: [UInt8]
    
    var lsb: UInt8 { bytes[1] }
    var msb: UInt8 { bytes[2] }
    var value: UInt16 { UInt16(msb) << 8 + UInt16(lsb) }
}

struct MidiSongSelect: MidiSystemCommonMessage {
    var type: MidiMessageType { .songSelect }
    let bytes: [UInt8]
    
    var song: UInt8 { bytes[1] }
}

struct MidiTuneRequest: MidiSystemCommonMessage {
    var type: MidiMessageType { .tuneRequest }
    let bytes: [UInt8]
}
