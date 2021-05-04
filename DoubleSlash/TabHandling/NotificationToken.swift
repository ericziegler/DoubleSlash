//
// NotificationToken.swift
//

import Foundation

final class NotificationToken: NSObject {

    // MARK: - Properties

    let notificationCenter: NotificationCenter
    let token: Any

    // MARK: - Init / Deinit

    init(notificationCenter: NotificationCenter = .default, token: Any) {
        self.notificationCenter = notificationCenter
        self.token = token
    }

    deinit {
        notificationCenter.removeObserver(token)
    }
}

extension NotificationCenter {

    func observe(name: NSNotification.Name?, object obj: Any?, queue: OperationQueue? = nil, using block: @escaping (Notification) -> ()) -> NotificationToken {
        let token = addObserver(forName: name, object: obj, queue: queue, using: block)
        return NotificationToken(notificationCenter: self, token: token)
    }

}
