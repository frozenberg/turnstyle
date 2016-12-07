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
            
            myCell.hostingFlagOut.text = "Attending"
            myCell.hostingFlagOut.textColor = UIColor.lightGray
        }
        
        let imageID:String = (eventArray[indexPath.row].event.eventId)
        let reference: FIRStorageReference = STORAGE_REF!.child("eventpictures/\(imageID)")
        
        if (myCell.eventID == loading){
            uploadTask?.observe(.progress){snapshot in
                myCell.loadingCircle.isHidden = false
                myCell.loadingCircle.startAnimating()
            }
            uploadTask?.observe(.success){snapshot in
                print("success")
                myCell.cellImage.sd_setImage(with: reference , placeholderImage: UIImage(imageLiteralResourceName: "635878692300261322-1064813558_28176-1"))
                myCell.loadingCircle.isHidden = true
            }
        }
        
        myCell.cellImage.sd_setImage(with: reference , placeholderImage: UIImage(imageLiteralResourceName: "635878692300261322-1064813558_28176-1"))
        
        
        return myCell
        
    }
	
	//redirect based on each user's relation to the event (host/guest)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(eventArray[indexPath.row].attending == true){
            let ticketView = TicketsViewController(nibName: "TicketViewController", bundle: nil)
            ticketView.event = eventArray[indexPath.row].event
            self.navigationController?.pushViewController(ticketView, animated: true)
        }
        else{
            let eventDetailVC = EventDetailView(nibName: "EventDetailView", bundle: nil)
            eventDetailVC.event = eventArray[indexPath.row].event
            self.navigationController?.pushViewController(eventDetailVC, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name:Globals.FONT, size:18.0)!]
        tableViewOut.register(UINib(nibName: "EventViewCell", bundle: nil), forCellReuseIdentifier: "EventViewCell")
		
        super.viewDidLoad()
        tableViewOut.reloadData()
        tableViewOut.dataSource = self
        tableViewOut.delegate = self
        
        //get events from firebase
        DatabaseOperations.getEvents(populateArray:{(newEvents: [(Event, Bool)]) in
            self.eventArray = newEvents
            self.tableViewOut.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let row = tableViewOut.indexPathForSelectedRow {
            self.tableViewOut.deselectRow(at: row, animated: false)
        }
        
    }
}

