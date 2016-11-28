//
//  eventForm.swift
//  Turnstyle
//
//  Created by Ross Arkin on 11/16/16.
//  Copyright © 2016 6164 Productions. All rights reserved.
//

import UIKit
import Firebase

class EventForm: UIViewController {
    
    @IBOutlet weak var hostNameOut: UITextField!
    @IBOutlet weak var eventNameOut: UITextField!
    @IBOutlet weak var locationOut: UITextField!
    @IBOutlet weak var priceOut: UITextField!
    @IBOutlet weak var numTixOut: UITextField!
    @IBOutlet weak var dateOut: UIDatePicker!
    @IBOutlet weak var descriptionOut: UITextView!
    
    
    @IBAction func createEvent(_ sender: Any) {
        //TODO check all of these for no user input
        let hostName = hostNameOut.text
        let eventName = eventNameOut.text
        let location = locationOut.text
        
        //TODO convert price string to Double
        let price = priceOut.text
        
        //TODO convert numTix string to Int
        let numTix = numTixOut.text
        
        let date = dateOut.date
        let description = descriptionOut.text
        
        //TODO url generation
        
        var newEvent = Event(cost: 5.0,
                             ticketsLeft: 10,
                             host: hostName!,
                             name: eventName!,
                             location: location!,
                             eventDate: date,
                             description: description!,
                             url: "turnstyle.com",
                             eventTime: Date())
        
        let EVENTS_REF = Globals.FIREBASE_REF?.child("events")
        let newEventEntry = EVENTS_REF?.childByAutoId()
        
        newEvent.setId(id: newEventEntry!.key)
        
        newEventEntry?.setValue(newEvent.toAnyObject())
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
