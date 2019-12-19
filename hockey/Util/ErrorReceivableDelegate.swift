//
//  ErrorReceivableDelegate.swift
//  hockey
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

// MARK: - Error Message Alert Controller Extension
extension UIViewController {
	func handleError(_ errorMessage: String) {
		let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		alert.addAction(okAction)
		present(alert, animated: true)
	}
}


// MARK: - Error Delegate
protocol ErrorReceivableDelegate: class {
	func didReceiveError(_ errorMessage: String)
}

extension ErrorReceivableDelegate where Self: UIViewController & SpinnerProtocol {
	func didReceiveError(_ errorMessage: String) {
		DispatchQueue.main.async {
			self.activityIndicator.stopAnimating()
			self.activityIndicator.isHidden = true
			self.handleError(errorMessage)
		}
	}
}

extension ErrorReceivableDelegate where Self: UIViewController {
	func didReceiveError(_ errorMessage: String) {
		DispatchQueue.main.async {
			self.handleError(errorMessage)
		}
	}
}
