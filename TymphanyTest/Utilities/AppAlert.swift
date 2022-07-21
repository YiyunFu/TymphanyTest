//
//  AppAlert.swift
//  TymphanyTest
//
//  Created by 傅意芸 on 2022/7/21.
//

import UIKit

class AppAlert {
    static let shared = AppAlert()
    
    private var currentAlert = [UIAlertController]()
    
    private var currentVC: UIViewController? {
        return SceneDelegate.shared.currentVC
    }
    
    private func present(_ alert: UIAlertController) {
        if let _ = currentVC?.presentedViewController as? UIAlertController {
            currentAlert.append(alert)
            return
        }
        currentVC?.present(alert, animated: true, completion: {
            print("present alert completion: \(alert.message ?? "")")
        })
    }
    
    private func didDismissAlert(_ alert: UIAlertController) {
        if let index = currentAlert.firstIndex(of: alert) {
            currentAlert.remove(at: index)
        }
        
        if let first = currentAlert.first {
            present(first)
        }
    }
    
    func showWarning(
        title: String = "AppAlert_Warning",
        message: String,
        confirmTitle: String = "AppAlert_Confirm"
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: confirmTitle, style: .cancel, handler: { [weak self] _ in
            self?.didDismissAlert(alert)
        }))
        present(alert)
    }
    
    func showAsk(
        title: String = "AppAlert_Warning",
        message: String,
        cancelTitle: String = "AppAlert_Cancel",
        cancelHandler: (()->())? = nil,
        confirmTitle: String = "AppAlert_Confirm",
        confirmHandler: (()->())? = nil
    ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: { [weak self] _ in
            cancelHandler?()
            self?.didDismissAlert(alert)
        }))
        alert.addAction(UIAlertAction(title: confirmTitle, style: .default, handler: { [weak self] _ in
            confirmHandler?()
            self?.didDismissAlert(alert)
        }))
        present(alert)
    }
}
