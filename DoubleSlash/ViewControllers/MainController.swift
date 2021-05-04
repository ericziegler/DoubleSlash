//
//  MainController.swift
//  DoubleSlash
//
//  Created by Eric Ziegler on 5/4/21.
//

import Cocoa

class MainController: NSViewController, NSTextViewDelegate {

    // MARK: - Properties

    @IBOutlet var textView: NSTextView!

    private let CloseSquareBracketKeyCode: UInt16 = 30
    private let OpenSquareBracketKeyCode: UInt16 = 33
    private var lines = [String]()

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        monitorEvents()
        setupTextView()
    }

    private func setupTextView() {
        textView.setUpLineNumberView()
        textView.font = NSFont(name: "RobotoMono-Medium", size: 13)
        textView.string = "// TODO:\n========\n"
        updateLines(string: textView.string)
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        updateWindowTitle()
    }

    // MARK: - Helpers

    private func updateLines(string: String) {
        lines = string.components(separatedBy: "\n")
    }

    private func updateWindowTitle() {
        self.view.window?.title = lines.first ?? "New Window"
    }

    // MARK: - NSTextViewDelegate

    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            if commandSelector == #selector(insertNewline) {
            updateLines(string: textView.string)
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
        }
        else if commandSelector == #selector(insertTab) {
            textView.string = textView.string + "\t"
            return true
        } else {
            return false
        }
    }

    func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        let updatedString = textView.string.replacingCharacters(in: affectedCharRange.toRange(textView.string), with: replacementString!) as String
        updateLines(string: updatedString)
        updateWindowTitle()
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



