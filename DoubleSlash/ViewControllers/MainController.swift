//
//  MainController.swift
//  DoubleSlash
//
//  Created by Eric Ziegler on 5/4/21.
//

import Cocoa

class MainController: NSViewController, NSTextViewDelegate, NSMenuDelegate {

    // MARK: - Properties

    static let storyboardId = "MainControllerId"

    @IBOutlet var textView: NSTextView!
    @IBOutlet var cursorLabel: NSTextField!

    private let CloseSquareBracketKeyCode: UInt16 = 30
    private let OpenSquareBracketKeyCode: UInt16 = 33
    private var lines = [String]()
    private var endingLinePositions = [Int]()
    private var cursorPosition: Int {
        return textView.selectedRanges.first?.rangeValue.location ?? 0
    }
    private var curLineNumber: Int {
        if endingLinePositions.count > 0 {
            for (i, curEndPosition) in endingLinePositions.enumerated() {
                if cursorPosition < curEndPosition {
                    return i
                }
            }
        }
        return 0
    }
    var doc: SlashDoc!

    // MARK: - Init

    static func createControllerFor(doc: SlashDoc?) -> MainController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateController(withIdentifier: MainController.storyboardId) as! MainController
        if let doc = doc {
            controller.doc = doc
        } else {
            controller.doc = DocManager.shared.createDoc()
        }
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        monitorEvents()
        setupTextView()
    }

    private func setupTextView() {
        textView.setUpLineNumberView()
        textView.font = NSFont(name: "Courier New Bold", size: 16)
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        textView.string = doc.text
        updateTextColor()
        updateText()
        updateCursorLabel()
    }

    // MARK: - Helpers

    private func updateText(updatedText: String? = nil) {
        let text = updatedText ?? textView.string
        lines = text.components(separatedBy: "\n")
        doc.text = text
        DocManager.shared.save()
        endingLinePositions.removeAll()
        var charCount = 0
        for i in 0..<lines.count {
            // add one to the character count to include the \n
            charCount = charCount + lines[i].count + 1
            endingLinePositions.append(charCount)
        }
        if let firstLine = lines.first, firstLine.count > 0 {
            self.view.window?.tab.title = firstLine
        } else {
            self.view.window?.tab.title = "New Document"
        }
    }

    private func updateTextColor() {
        textView.textColor = doc.color.value
    }

    private func updateCursorLabel() {
        if textView.selectedRange().length > 0 {
            cursorLabel.stringValue = "\(textView.selectedRange().length) characters selected"
        } else {
            var offset = 0
            for i in 0..<curLineNumber {
                offset += lines[i].count + 1
            }
            var curColumn = textView.selectedRange().location - offset
            var tabSpacing = 0
            if lines.count > 0 {
                let curLine = lines[curLineNumber]
                for i in 0..<curColumn {
                    if curLine[i] == "\t" {
                        // add 3 spaces for each tab leading up to the cursor position
                        tabSpacing += 3
                    }
                }
            }
            curColumn += tabSpacing
            curColumn += 1 // new line
            let strippedText = textView.string.replacingOccurrences(of: "\t", with: "    ").replacingOccurrences(of: "\n", with: "")
            cursorLabel.stringValue = "Line \(curLineNumber + 1), Column \(curColumn) - Total Characters: \(strippedText.count)"
        }
    }

    func askToClose() -> Bool {
        let alert = NSAlert()
        alert.messageText = "Are you sure you would like to close this document?"
        alert.informativeText = "This action cannot be undone."
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: "Close")
        alert.addButton(withTitle: "Cancel")
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            return true
        } else {
            return false
        }
    }

    func prepareToClose() {
        DocManager.shared.remove(doc: doc)
    }

    // MARK: - Actions

    @IBAction func colorTapped(_ sender: Any?) {
        if let menuItem = sender as? NSMenuItem, let color = SlashDocColor(rawValue: menuItem.tag) {
            doc.color = color
            DocManager.shared.save()
            updateTextColor()
        }
    }

    // MARK: - NSTextViewDelegate

    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(insertNewline(_:)) {
            updateText()
            let curLine = lines[curLineNumber]
            // split on tabs, loop through, and determine how many are at the start of the line
            let tabs = curLine.components(separatedBy: "\t")
            var tabCount = 0
            if tabs.count > 1 {
                for curTab in tabs {
                    if curTab.count == 0 {
                        tabCount += 1
                    } else {
                        break
                    }
                }
            }
            // add the number of tabs to the new line
            var stringToInsert = "\n"
            if tabCount > 0 {
                for _ in 0 ..< tabCount {
                    stringToInsert += "\t"
                }
            }

            textView.insertText(stringToInsert, replacementRange: textView.selectedRange())
            updateText()
            return true
        } else {
            return false
        }
    }

    func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        let updatedString = textView.string.replacingCharacters(in: affectedCharRange.toRange(textView.string), with: replacementString!) as String
        updateText(updatedText: updatedString)
        return true
    }

    func textViewDidChangeSelection(_ notification: Notification) {
        updateCursorLabel()
    }

    // MARK: - NSMenuDelegate

    func menuWillOpen(_ menu: NSMenu) {
        for curItem in menu.items {
            if curItem.tag == doc.color.rawValue {
                curItem.state = .on
            } else {
                curItem.state = .off
            }
        }
    }

    // MARK: - Events

    private func monitorEvents() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
    }

    override func keyDown(with event: NSEvent) {
        guard let window = textView.window, let tabGroup = window.tabGroup, tabGroup.selectedWindow == window else {
            return
        }

        if event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command {
            if event.keyCode == OpenSquareBracketKeyCode {
                // indent highlighted text backward
                if textView.selectedRange().length > 0 {
                    // indent selection
                } else {
                    // nothing selected. indent current line
                }
            }
            else if event.keyCode == CloseSquareBracketKeyCode {
                // indent highlighted text forward
                if textView.selectedRange().length > 0 {
                    // indent selection
                } else {
                    // nothing selected. indent current line
                }
            }
        }
    }

}



