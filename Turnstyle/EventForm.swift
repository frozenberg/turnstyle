//
//  eventForm.swift
//  Turnstyle
//
//  Created by Ross Arkin on 11/16/16.
//  Copyright © 2016 6164 Productions. All rights reserved.
//

import UIKit
import Firebase

class EventForm: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var hostNameOut: UITextField!
    @IBOutlet weak var eventNameOut: UITextField!
    @IBOutlet weak var locationOut: UITextField!
    @IBOutlet weak var priceOut: UITextField!
    @IBOutlet weak var numTixOut: UITextField!
    @IBOutlet weak var dateOut: UIDatePicker!
    @IBOutlet weak var descriptionOut: UITextView!
   
    
    
    
    @IBAction func createEvent(_ sender: Any) {
        
        
        //trim whitespace to prevent blank fields
        hostNameOut.text =  hostNameOut.text?.trimmingCharacters(in: .whitespaces)
        eventNameOut.text =  eventNameOut.text?.trimmingCharacters(in: .whitespaces)
        locationOut.text =  locationOut.text?.trimmingCharacters(in: .whitespaces)
        priceOut.text =  priceOut.text?.trimmingCharacters(in: .whitespaces)
        numTixOut.text =  numTixOut.text?.trimmingCharacters(in: .whitespaces)
        
        //check for user input
        if ((hostNameOut.text?.isEmpty)! || (eventNameOut.text?.isEmpty)! || (locationOut.text?.isEmpty)! || (priceOut.text?.isEmpty)! || (numTixOut.text?.isEmpty)!){
            
            //code to create a pop up notifying user of invalid input
            let popUp = UIAlertController(title: "Invalid Form", message: "Please fill out all fields", preferredStyle: UIAlertControllerStyle.alert)
            popUp.addAction(UIAlertAction(title: "Okay I'm dumb", style: UIAlertActionStyle.default, handler: nil))
            self.present(popUp, animated: true, completion: nil)

        }
        else{
        let hostName = hostNameOut.text
        
        let eventName = eventNameOut.text
        let location = locationOut.text
        
        let cost = NumberFormatter().number(from: priceOut.text!)?.doubleValue

        let numTix = NumberFormatter().number(from: numTixOut.text!)?.intValue
        
        let date = dateOut.date
        let description = descriptionOut.text
        
        //TODO url generation
        
            //check if cost field is a number
            if (cost == nil || cost! < 0.0){
                priceOut.text = ""
                
                //same pop up code
                let popUp = UIAlertController(title: "Invalid Form", message: "Please enter a valid price", preferredStyle: UIAlertControllerStyle.alert)
                popUp.addAction(UIAlertAction(title: "Okay I'm dumb", style: UIAlertActionStyle.default, handler: nil))
                self.present(popUp, animated: true, completion: nil)
            }
            
            //check if ticket field is a number
            else if (numTix == nil || numTix! < 0){
                numTixOut.text = ""
                
                //same pop up code
                let popUp = UIAlertController(title: "Invalid Form", message: "Please enter a valid number of tickets", preferredStyle: UIAlertControllerStyle.alert)
                popUp.addAction(UIAlertAction(title: "Okay I'm dumb", style: UIAlertActionStyle.default, handler: nil))
                self.present(popUp, animated: true, completion: nil)
            }
                
            else{
                var newEvent = Event(cost: cost!,
                             ticketsLeft: numTix!,
                             host: hostName!,
                             name: eventName!,
                             location: location!,
                             eventDate: date,
                             description: description!,
                             url: "turnstyle.com"
                            )
        
                let EVENTS_REF = Globals.FIREBASE_REF?.child("events")
                let newEventEntry = EVENTS_REF?.childByAutoId()
        
                newEvent.setId(id: newEventEntry!.key)
        
                newEventEntry?.setValue(newEvent.toAnyObject())
        }
        
                navigationController?.popViewController(animated: true) //return to previous view
            }
    }
    
    
    
    
    //Additional styling to form
    func styleForm(){
        hostNameOut.font = UIFont(name:"BebasNeue", size:15.0)
        eventNameOut.font = UIFont(name:"BebasNeue", size:15.0)
        locationOut.font = UIFont(name:"BebasNeue", size:15.0)
        priceOut.font = UIFont(name:"BebasNeue", size:15.0)
        numTixOut.font = UIFont(name:"BebasNeue", size:15.0)
        descriptionOut.text = "Description"
        descriptionOut.textColor = UIColor.lightGray
        descriptionOut.font = UIFont(name:"BebasNeue", size:15.0)
        
    }
    
    
    
    //Create Placeholder text for Description Text View
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
        }
    }
    //
    
    
    override func viewDidLoad() {
        //styling
        styleForm()
        descriptionOut.delegate = self
        //
        
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
