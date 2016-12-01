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
    
    var eventArray : [Event] = []
    let FIREBASE_REF = FIRDatabase.database().reference()
    let storageRef = FIRStorage.storage().reference()
    
    func position(for bar: UIBarPositioning) -> UIBarPosition{
        return .topAttached;
    }


    @IBAction func addEvent(_ sender: Any) {
        let eventFormViewController = EventForm(nibName: "EventForm", bundle: nil)
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
        
        myCell.eventNameOut.text = eventArray[indexPath.row].getName()
        
        let imageID:String = (eventArray[indexPath.row].eventId)
        let reference: FIRStorageReference = storageRef.child("eventpictures/\(imageID)")
        myCell.cellImage.sd_setImage(with: reference, placeholderImage: UIImage(imageLiteralResourceName: "635878692300261322-1064813558_28176-1"))
        
        
        return myCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailVC = EventDetailView(nibName: "EventDetailView", bundle: nil)
        eventDetailVC.event = eventArray[indexPath.row]
        self.navigationController?.pushViewController(eventDetailVC, animated: true)
    }
    
    override func viewDidLoad() {
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name:"BebasNeue", size:18.0)!]
        tableViewOut.register(UINib(nibName: "EventViewCell", bundle: nil), forCellReuseIdentifier: "EventViewCell")
        
        super.viewDidLoad()
        tableViewOut.reloadData()
        tableViewOut.dataSource = self
        tableViewOut.delegate = self
        
        
        DatabaseOperations.getEvents(populateArray:{(newEvents: [Event]) in
            self.eventArray = newEvents
            self.tableViewOut.reloadData()
        })
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let row = tableViewOut.indexPathForSelectedRow {
            self.tableViewOut.deselectRow(at: row, animated: false)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

