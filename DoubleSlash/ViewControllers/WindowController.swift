//
//  WindowController.swift
//  DoubleSlash
//
//  Created by Eric Ziegler on 5/4/21.
//

import Cocoa

// MARK: - Protocols

protocol TabDelegate: class {
    func createTab(newWindowController: WindowController, inWindow window: NSWindow, ordered orderingMode: NSWindow.OrderingMode)
}

class WindowController: NSWindowController, NSWindowDelegate {

    // MARK: - Properties

    static let storyboardId = "WindowControllerId"

    weak var tabDelegate: TabDelegate?

    // MARK: - Init

    static func create(doc: SlashDoc? = nil) -> WindowController {
        let windowStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = windowStoryboard.instantiateController(withIdentifier: WindowController.storyboardId) as! WindowController
        let mainController = MainController.createControllerFor(doc: doc)
        windowController.contentViewController = mainController
        return windowController
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window!.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
        self.window!.delegate = self
        self.window!.title = "Double Slash"

    }

    // MARK: - TabDelegate

    override func newWindowForTab(_ sender: Any?) {
        guard let window = self.window else { preconditionFailure("Expected window to be loaded") }
        guard let tabDelegate = self.tabDelegate else { return }

        tabDelegate.createTab(newWindowController: WindowController.create(), inWindow: window, ordered: .above)
    }

    // MARK: - NSWindowDelegate

    func askToClose() -> Bool {
        guard let mainController = self.window?.contentViewController as? MainController else {
            return false
        }

        if mainController.askToClose() == true {
            mainController.prepareToClose()
            return true
        } else {
            return false
        }
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        return askToClose()
    }

}

