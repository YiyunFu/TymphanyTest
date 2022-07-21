//
//  PermissionHandler.swift
//  TymphanyTest
//
//  Created by 傅意芸 on 2022/7/21.
//

import UIKit

class PermissionHandler: NSObject {
    static func showSettingsAlert(message: String? = nil, cancelHandler:  (()->())? = nil) {
        AppAlert.shared.showAsk(
            message: message ?? "AppAlert_Message_Permissions",
            cancelTitle: "AppAlert_Quit",
            cancelHandler: cancelHandler,
            confirmTitle: "AppAlert_GoSettings",
            confirmHandler: {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
        )
    }
}
