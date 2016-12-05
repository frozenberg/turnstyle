//
//  EventsViewController.swift
//  Turnstyle
//
//  Copyright © 2016 6164 Productions. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseStorageUI

class EventsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {


    
    @IBOutlet var tableViewOut: UITableView!
    
    var eventArray : [(event: Event, attending: Bool)] = []
    var loading: String? = nil
    var uploadTask: FIRStorageUploadTask? = nil
    
    let FIREBASE_REF = Globals.FIREBASE_REF
    let STORAGE_REF = Globals.STORAGE_REF
    
    func position(for bar: UIBarPositioning) -> UIBarPosition{
        return .topAttached;
    }


    @IBAction func addEvent(_ sender: Any) {
        let eventFormViewController = EventForm(nibName: "EventForm", bundle: nil)
        eventFormViewController.parentView = self
        self.navigationController?.pushViewController(eventFormViewController, animated: true)
    }
    
    func buttonAction(sender: UIButton!) {
        print("Button tapped")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let myCell = tableViewOut.dequeueReusableCell(withIdentifier: "EventViewCell") as! EventViewCell
        myCell.eventID = eventArray[indexPath.row].event.eventId
        myCell.eventNameOut.text = eventArray[indexPath.row].event.getName()
        myCell.hostingFlagOut.text = "Hosting"
        myCell.hostingFlagOut.textColor = Globals.ORANGE
        if(eventArray[indexPath.row].attending == true){
            print("in herer \(indexPath.row)")
            myCell.hostingFlagOut.text = "Attending"
            myCell.hostingFlagOut.textColor = UIColor.lightGray
        }
        
        let imageID:String = (eventArray[indexPath.row].event.eventId)
        let reference: FIRStorageReference = STORAGE_REF!.child("eventpictures/\(imageID)")
        
        if (myCell.eventID == loading){
            let observer = uploadTask?.observe(.progress){snapshot in
                myCell.loadingCircle.isHidden = false
                myCell.loadingCircle.startAnimating()
            }
            let success = uploadTask?.observe(.success){snapshot in
                print("success")
                myCell.cellImage.sd_setImage(with: reference , placeholderImage: UIImage(imageLiteralResourceName: "635878692300261322-1064813558_28176-1"))
                myCell.loadingCircle.isHidden = true
            }
        }
        
        myCell.cellImage.sd_setImage(with: reference , placeholderImage: UIImage(imageLiteralResourceName: "635878692300261322-1064813558_28176-1"))
        
        
        return myCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailVC = EventDetailView(nibName: "EventDetailView", bundle: nil)
        eventDetailVC.event = eventArray[indexPath.row].event
		self.navigationController?.pushViewController(eventDetailVC, animated: true)
    }
    
    
    override func viewDidLoad() {
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name:Globals.FONT, size:18.0)!]
        tableViewOut.register(UINib(nibName: "EventViewCell", bundle: nil), forCellReuseIdentifier: "EventViewCell")
		
        super.viewDidLoad()
        tableViewOut.reloadData()
        tableViewOut.dataSource = self
        tableViewOut.delegate = self
        
        
        DatabaseOperations.getEvents(populateArray:{(newEvents: [(Event, Bool)]) in
            self.eventArray = newEvents
            self.tableViewOut.reloadData()
        })
		
    }
	
	func checkIfComingFromURL(){
		if(Globals.TICKET_FROM_URL != ""){
			DatabaseOperations.getEvent(withId: Globals.TICKET_FROM_URL, populateArray:{(newEvents: [Event]) in
				let requestedEventArray = newEvents
				let eventDetailVC = EventDetailView(nibName: "EventDetailView", bundle: nil)
				eventDetailVC.event = requestedEventArray[0]
				self.navigationController?.pushViewController(eventDetailVC, animated: true)
			})
			Globals.TICKET_FROM_URL = ""
		}
	}
    
    override func viewWillAppear(_ animated: Bool) {
		NotificationCenter.default.addObserver(self, selector: #selector(checkIfComingFromURL), name: .UIApplicationWillEnterForeground, object: nil)
		checkIfComingFromURL()
        if let row = tableViewOut.indexPathForSelectedRow {
            self.tableViewOut.deselectRow(at: row, animated: false)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

