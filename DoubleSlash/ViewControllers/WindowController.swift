//
//  WindowController.swift
//  DoubleSlash
//
//  Created by Eric Ziegler on 5/4/21.
//

import Cocoa

protocol TabDelegate: class {
    func createTab(newWindowController: WindowController,
                   inWindow window: NSWindow,
                   ordered orderingMode: NSWindow.OrderingMode)
}

class WindowController: NSWindowController {

    static func create() -> WindowController {
        let windowStoryboard = NSStoryboard(name: "WindowController", bundle: nil)
        return windowStoryboard.instantiateInitialController() as! WindowController
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window!.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
    }

    weak var tabDelegate: TabDelegate?

    override func newWindowForTab(_ sender: Any?) {

        guard let window = self.window else { preconditionFailure("Expected window to be loaded") }
        guard let tabDelegate = self.tabDelegate else { return }

        tabDelegate.createTab(newWindowController: WindowController.create(),
                              inWindow: window,
                              ordered: .above)

    }

}

