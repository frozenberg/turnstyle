//
//  PaymentViewController.swift
//  Turnstyle
//
//  Copyright © 2016 6164 Productions. All rights reserved.
//

import UIKit
import Stripe

class PaymentViewController: UIViewController, STPPaymentCardTextFieldDelegate, CardIOPaymentViewControllerDelegate {


	@IBOutlet weak var purchaseButton: UIButton!
	@IBOutlet weak var errorLabel: UILabel!
	
	var event: Event? = nil //this event is set before the view loads
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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		CardIOUtilities.preload()
	}

	//Pay button tapped
	@IBAction func payButtonTapped(_ sender: Any) {
		let card = paymentTextField.cardParams
		getStripeToken(card: card)
	}
	
	//Make API Call to Stripe
	func getStripeToken(card:STPCardParams) {
		STPAPIClient.shared().createToken(withCard: card) { token, error in
			if let token = token {
				self.event?.attendeeList.append(Globals.USERID)
				self.event?.ticketsLeft -= 1;
				//Updtae firebase
				Globals.FIREBASE_REF?.child("events").child((self.event?.eventId)!).setValue(self.event?.toAnyObject())
			} else {
				self.errorLabel.text = error!.localizedDescription
			}
		}
	}
	
	//validate card number if manually inputted
	private func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
		if textField.valid{
			purchaseButton.isEnabled = true
		}
	}
	
	//CARD IO scanning
	
	@IBAction func scanCard(_ sender: Any) {
		let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
		cardIOVC?.modalPresentationStyle = .formSheet
		cardIOVC?.hideCardIOLogo = true
		present(cardIOVC!, animated: true, completion: nil)
	}
	
	public func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
		paymentViewController?.dismiss(animated: true, completion: nil)
	}
	
	public func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
		if let info = cardInfo {
			paymentViewController?.dismiss(animated: true, completion: nil)
			
			//create Stripe card
			let card: STPCardParams = STPCardParams()
			card.number = info.cardNumber
			card.expMonth = info.expiryMonth
			card.expYear = info.expiryYear
			card.cvc = info.cvv
			
			//Send to Stripe
			getStripeToken(card: card)
			
		}
	}
}
