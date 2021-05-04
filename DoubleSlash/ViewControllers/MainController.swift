//
//  MainController.swift
//  DoubleSlash
//
//  Created by Eric Ziegler on 5/4/21.
//

import Cocoa

class MainController: NSViewController, NSTextViewDelegate {

    // MARK: - Properties

    static let storyboardId = "MainControllerId"

    @IBOutlet var textView: NSTextView!

    private let CloseSquareBracketKeyCode: UInt16 = 30
    private let OpenSquareBracketKeyCode: UInt16 = 33
    private var lines = [String]()
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
        textView.font = NSFont(name: "RobotoMono-Medium", size: 13)
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        if doc.text.count == 0 {
            textView.string = "// TODO:\n========\n"
        } else {
            textView.string = doc.text
        }
        updateText()
    }

    // MARK: - Helpers

    private func updateText(updatedText: String? = nil) {
        let text = updatedText ?? textView.string
        lines = text.components(separatedBy: "\n")
        doc.text = text
        DocManager.shared.save()
        self.view.window?.tab.title = lines.first ?? "New Window"
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

    // MARK: - NSTextViewDelegate

    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            if commandSelector == #selector(insertNewline) {
            updateText()
            textView.string = textView.string + "\n"
            if let lastLine = lines.last {
                let tabs = lastLine.components(separatedBy: "\t")
                var tabCount = 0
                for curTab in tabs {
                    if curTab.count == 0 {
                        tabCount += 1
                    } else {
                        break
                    }
                }
                if tabCount > 0 {
                    for _ in 0 ..< tabCount {
                        textView.string += "\t"
                    }
                }
            }
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

    // MARK: - Events

    private func monitorEvents() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
    }

    override func keyDown(with event: NSEvent) {
        if event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command {
//            let curorPosition = textView.selectedRanges.first?.rangeValue.location ?? 0
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



