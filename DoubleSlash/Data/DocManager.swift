//
//  DocManager.swift
//  DoubleSlash
//
//  Created by Eric Ziegler on 5/4/21.
//

import Foundation

class DocManager {

    // MARK: - Properties

    private let DocManagerDocsCacheKey = "DocManagerDocsCacheKey"

    private var docs = [SlashDoc]()
    var docCount: Int {
        return docs.count
    }
    var orderedDocs: [SlashDoc] {
        return docs.sorted(by: { $0.index < $1.index })
    }

    // MARK: - Init

    static let shared = DocManager()

    init() {
        load()
    }

    // MARK: - Loading / Saving

    func load() {
        do {
            if let docsData = UserDefaults.standard.object(forKey: DocManagerDocsCacheKey) as? Data, let cachedDocs = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(docsData) as? [SlashDoc] {
                docs = cachedDocs
            }
        } catch {
            print("Could not load DocManager.docs.")
        }

        // create an initial doc if there isn't one
        if docs.count == 0 {
            _ = createDoc()
        }
    }

    func save() {
        let defaults = UserDefaults.standard
        do {
            let docsData = try NSKeyedArchiver.archivedData(withRootObject: docs, requiringSecureCoding: false)
            defaults.set(docsData, forKey: DocManagerDocsCacheKey)
        } catch {
            print("Could not save DocManager.docs.")
        }
        defaults.synchronize()
    }

    // MARK: - Doc Management

    func createDoc() -> SlashDoc {
        let doc = SlashDoc(index: docs.count)
        docs.append(doc)
        save()
        return doc
    }

    func remove(doc: SlashDoc) {
        for (i, curDoc) in docs.enumerated() {
            if curDoc.id == doc.id {
                docs.remove(at: i)
                save()
                break
            }
        }
    }

}
