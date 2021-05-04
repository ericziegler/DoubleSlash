//
//  AppDelegate.swift
//  DoubleSlash
//
//  Created by Eric Ziegler on 5/4/21.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // MARK: - Properties

    var tabService: TabService!

    // MARK: - UIApplicationDelegate

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        replaceTabServiceWithInitialWindow()
    }

    // MARK: - Actions

    @IBAction func newDocClicked(_ sender: Any?) {
        if let existingWindow = tabService.mainWindow {
            tabService.createTab(newWindowController: WindowController.create(), inWindow: existingWindow, ordered: .above)
        } else {
            replaceTabServiceWithInitialWindow()
        }
    }

    // MARK: - Helpers

    private func replaceTabServiceWithInitialWindow() {
        let manager = DocManager.shared

        let windowController = WindowController.create(doc: manager.orderedDocs.first)
        windowController.showWindow(self)
        tabService = TabService(initialWindowController: windowController)
        if manager.orderedDocs.count > 1 {
            for i in 1 ..< manager.orderedDocs.count {
                let doc = manager.orderedDocs[i]
                tabService.createTab(newWindowController: WindowController.create(doc: doc), inWindow: tabService.mainWindow!, ordered: .above)
            }
        }
    }

}

