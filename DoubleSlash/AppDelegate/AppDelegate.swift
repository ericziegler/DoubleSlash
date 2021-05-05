//
//  AppDelegate.swift
//  DoubleSlash
//
//  Created by Eric Ziegler on 5/4/21.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    // MARK: - Properties

    private var tabService: TabService!
    private var hasSavedTabOrder = false

    // MARK: - UIApplicationDelegate

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        replaceTabServiceWithInitialWindow()
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        if hasSavedTabOrder == false {
            saveTabOrder()
            return .terminateLater
        } else {
            return .terminateNow
        }
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

    private func saveTabOrder() {
        if let tabbedWindows = tabService.mainWindow?.tabbedWindows {
            for (i, curWindow) in tabbedWindows.enumerated() {
                if let mainController = curWindow.contentViewController as? MainController {
                    mainController.doc.index = i
                }
            }
        }
        DocManager.shared.save()
        hasSavedTabOrder = true
        NSApp.terminate(self)
    }

    // MARK: - NSMenuDelegate

    func menuWillOpen(_ menu: NSMenu) {
        if let curWindow = tabService.mainWindow, let mainController = curWindow.contentViewController as? MainController {
            let colorInt = mainController.doc.color.rawValue
            for curItem in menu.items {
                if curItem.tag == colorInt {
                    curItem.state = .on
                } else {
                    curItem.state = .off
                }
            }
        }
    }

}

