//
//  ViewMail.swift
//  spy-app
//
//  Created by Siriluk Rachaniyom on 3/5/2565 BE.
//

import UIKit
import MessageUI

class ViewController: UIViewController {
    
    @IBAction func emailButtonTapped(_ sender: SAButton) {
        // this needs to be run on a device
        showMailComposer()
    }
    
    func showMailComposer() {
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing the user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["support@seanallen.co"])
        composer.setSubject("HELP!")
        composer.setMessageBody("I love your videos, but.. help!", isHTML: false)
        
        present(composer, animated: true)
    }
    
}

extension ViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error {
            //show error alert
            controller.dismiss(animated: true)
            return
        }
        
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed to send")
        case .saved:
            print("Saved")
        case .sent:
            print("Email Sent")
        @unknown default:
            break
            
        }
        controller.dismiss(animated: true)
    }
    
}
