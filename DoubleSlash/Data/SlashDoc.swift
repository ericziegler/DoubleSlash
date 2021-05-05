//
//  SlashDoc.swift
//  DoubleSlash
//
//  Created by Eric Ziegler on 5/4/21.
//

import Foundation
import AppKit

// MARK: - Enums

enum SlashDocColor: Int {
    case blue
    case red
    case orange
    case purple
    case green
    case yellow
    case white

    var value: NSColor {
        switch self {
        case .blue:
            return NSColor(hex: 0x33d6ff)
        case .red:
            return NSColor(hex: 0xff6961)
        case .orange:
            return NSColor(hex: 0xffc368)
        case .purple:
            return NSColor(hex: 0xcdb7f6)
        case .green:
            return NSColor(hex: 0x26d68e)
        case .yellow:
            return NSColor(hex: 0xffdd3c)
        case .white:
            return NSColor(hex: 0xffffff)
        }
    }

}

class SlashDoc: NSObject, NSCoding {

    // MARK: - Properties

    private let SlashDocIdCacheKey = "SlashDocIdCacheKey"
    private let SlashDocIndexCacheKey = "SlashDocIndexCacheKey"
    private let SlashDocTextCacheKey = "SlashDocTextCacheKey"
    private let SlashDocColorCacheKey = "SlashDocColorCacheKey"

    var id = ""
    var index = 0
    var text = ""
    var color = SlashDocColor.blue

    // MARK: - Init

    override init() {

    }

    init(index: Int) {
        self.id = UUID().uuidString
        self.index = index
    }

    // MARK: - NSCoding

    required init?(coder decoder: NSCoder) {
        if let cachedId = decoder.decodeObject(forKey: SlashDocIdCacheKey) as? String {
            id = cachedId
        }
        if let cachedIndexNumber = decoder.decodeObject(forKey: SlashDocIndexCacheKey) as? NSNumber {
            index = cachedIndexNumber.intValue
        }
        if let cachedText = decoder.decodeObject(forKey: SlashDocTextCacheKey) as? String {
            text = cachedText
        }
        if let cachedColorValue = decoder.decodeObject(forKey: SlashDocColorCacheKey) as? NSNumber, let cachedColor = SlashDocColor(rawValue: cachedColorValue.intValue) {
            color = cachedColor
        }
    }

    func encode(with encoder: NSCoder) {
        encoder.encode(id, forKey: SlashDocIdCacheKey)
        encoder.encode(NSNumber(value: index), forKey: SlashDocIndexCacheKey)
        encoder.encode(text, forKey: SlashDocTextCacheKey)
        encoder.encode(NSNumber(value: color.rawValue), forKey: SlashDocColorCacheKey)
    }

}
