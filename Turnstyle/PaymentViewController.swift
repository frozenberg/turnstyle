//
//  PaymentViewController.swift
//  Turnstyle
//
//  Created by Rohan Bhansali on 6/12/16.
//  Copyright © 2016 6164 Productions. All rights reserved.
//

import UIKit
import Stripe

class PaymentViewController: UIViewController, STPPaymentCardTextFieldDelegate {

	@IBOutlet weak var purchaseButton: UIButton!
	@IBOutlet weak var scanButton: UIButton!
	
	var paymentTextField: STPPaymentCardTextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		purchaseButton.layer.cornerRadius = 5
		let frame1 = CGRect(x: 20, y: 150, width: self.view.frame.size.width - 40, height: 40)
		paymentTextField = STPPaymentCardTextField(frame: frame1)
		paymentTextField.center = view.center
		paymentTextField.delegate = self
		view.addSubview(paymentTextField)
    }

	@IBAction func payButtonTapped(_ sender: Any) {
		print("payBtnTapped")
		let card = paymentTextField.cardParams
		getStripeToken(card: card)
	}
	
	func getStripeToken(card:STPCardParams) {
		STPAPIClient.shared().createToken(withCard: card) { token, error in
			if let token = token {
				print(token)
//				self.postStripeToken(token)
			} else {
				print(error)
			}
		}
	}

}
