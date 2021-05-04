//
//  SlashDoc.swift
//  DoubleSlash
//
//  Created by Eric Ziegler on 5/4/21.
//

import Foundation

class SlashDoc: NSObject, NSCoding {

    // MARK: - Properties

    private let SlashDocIdCacheKey = "SlashDocIdCacheKey"
    private let SlashDocIndexCacheKey = "SlashDocIndexCacheKey"
    private let SlashDocTextCacheKey = "SlashDocTextCacheKey"

    var id = ""
    var index = 0
    var text = ""

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
    }

    func encode(with encoder: NSCoder) {
        encoder.encode(id, forKey: SlashDocIdCacheKey)
        encoder.encode(NSNumber(value: index), forKey: SlashDocIndexCacheKey)
        encoder.encode(text, forKey: SlashDocTextCacheKey)
    }

}
