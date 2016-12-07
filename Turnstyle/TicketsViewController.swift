//
//  TicketsViewController.swift
//  Turnstyle
//
//  Copyright © 2016 6164 Productions. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseStorageUI

class TicketsViewController: UIViewController {
	
	var event: Event? = nil //this event is set before the view loads
	var attendeeList: [String]? = nil
	var attendedList: [String]? = nil
	let storageRef = Globals.STORAGE_REF!

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var host: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var urllabel: UILabel!
    @IBOutlet weak var detailDescription: UILabel!
    
    @IBOutlet weak var url: UITextView!
    
    @IBOutlet weak var eventImage: UIImageView!
	
	@IBOutlet weak var isScanned: UILabel!
    @IBOutlet weak var qrImage: UIImageView!
	@IBOutlet weak var purchaseBtn: UIButton!
    
    
	
	@IBAction func purchaseTicket(_ sender: UIButton) {
		let pvc=PaymentViewController()
		pvc.event = event;
		self.navigationController?.pushViewController(pvc, animated: true)
	}
    
    override func viewDidLoad() {
		super.viewDidLoad()
		//design and formatting tweaks
        attendeeList = (event?.attendeeList)!
		attendedList = (event?.attendedList)!
        style()
        loadImage()
        let cost_string = String(format:"%.2f",event!.ticketCost)
        name.text = (event?.name)!
        host.text = "Host: \((event?.host)!)"
        price.text = "Price: $\(cost_string)"
        location.text = "Location: \((event?.location)!)"
        detailDescription.text = "Description: \((event?.description)!)"
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        formatter.timeStyle = .short
        let newEventDate = formatter.string(from: event!.eventDate)
        date.text = "Date: \(newEventDate)"
        url.text = "\((event?.url)!)"
		
		//Event Listener to remove QR Code if scanned
		Globals.FIREBASE_REF?.child("events").child((self.event?.eventId)!).observe(FIRDataEventType.value, with: { (snapshot) in
			self.ticketAction()
		})
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		//get specific event from firebase
		DatabaseOperations.getEvent(withId: (self.event?.eventId)!, populateArray:{(newEvents: [Event]) in
			let requestedEventArray = newEvents
			self.event = requestedEventArray[0]
		})
	}
	
	//display correct action - QR Code, Purchase Ticket, isRedeemed
	func ticketAction(){
		if(attendedList?.contains(Globals.USERID))!{
			purchaseBtn.isHidden = true
			qrImage.isHidden = true
			isScanned.isHidden = false
		}
		else if(attendeeList?.contains(Globals.USERID))!{
			purchaseBtn.isHidden = true
			isScanned.isHidden = true
			let eventIDString = event?.eventId
			let userIDString = Globals.USERID
			let qrCodeString = "\(eventIDString!)/\(userIDString)"
			let qrCIImage = Globals.genQR(code: qrCodeString)
			Globals.scaleAndDisplayQRCodeImage(QR_img: qrCIImage, forView: qrImage)
			qrImage.isHidden = false
		}
		else{
			qrImage.isHidden = true
			isScanned.isHidden = true
			purchaseBtn.isHidden = false
		}
	}
	//change fonts
    func style(){
		ticketAction()
        urllabel.font = UIFont(name:Globals.FONT, size:18.0)
        name.font = UIFont(name:Globals.FONT, size:18.0)
        host.font = UIFont(name:Globals.FONT, size:18.0)
        price.font = UIFont(name:Globals.FONT, size:18.0)
        location.font = UIFont(name:Globals.FONT, size:18.0)
        date.font = UIFont(name:Globals.FONT, size:18.0)
        url.font = UIFont(name:Globals.FONT, size:18.0)
        detailDescription.font = UIFont(name:Globals.FONT, size:18.0)
    }
	
	//load banner image
    func loadImage(){
        let imageID:String = (event?.eventId)!
        let reference: FIRStorageReference = storageRef.child("eventpictures/\(imageID)")
        eventImage.sd_setImage(with: reference, placeholderImage: UIImage(imageLiteralResourceName: "635878692300261322-1064813558_28176-1"))
    }
}

