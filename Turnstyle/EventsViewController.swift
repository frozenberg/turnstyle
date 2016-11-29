//
//  EventsViewController.swift
//  Turnstyle
//
//  Copyright © 2016 6164 Productions. All rights reserved.
//

import UIKit
import Firebase

class EventsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {


    
    @IBOutlet var tableViewOut: UITableView!
    var eventArray : [Event] = []
    let FIREBASE_REF = FIRDatabase.database().reference()
    
    
    func position(for bar: UIBarPositioning) -> UIBarPosition{
        return .topAttached;
    }


    @IBAction func addEvent(_ sender: Any) {
        let eventFormViewController = EventForm(nibName: "EventForm", bundle: nil)
        self.navigationController?.pushViewController(eventFormViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        myCell.textLabel!.text = eventArray[indexPath.row].getName()
        
        
        return myCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailVC = EventDetailView(nibName: "EventDetailView", bundle: nil)
        eventDetailVC.event = eventArray[indexPath.row]
        self.navigationController?.pushViewController(eventDetailVC, animated: true)
    }
    
    override func viewDidLoad() {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

