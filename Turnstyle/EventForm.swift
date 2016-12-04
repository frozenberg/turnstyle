//
//  eventForm.swift
//  Turnstyle
//
//  Created by Ross Arkin on 11/16/16.
//  Copyright © 2016 6164 Productions. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class EventForm: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var hostNameOut: UITextField!
    @IBOutlet weak var eventNameOut: UITextField!
    @IBOutlet weak var locationOut: UITextField!
    @IBOutlet weak var priceOut: UITextField!
    @IBOutlet weak var numTixOut: UITextField!
    @IBOutlet weak var dateOut: UIDatePicker!
    @IBOutlet weak var descriptionOut: UITextView!

    @IBOutlet weak var imageOut: UIImageView!
    
    // code for uploading images
    var imageData = Data()
    var photoURL = NSURL()
    let imagePicker = UIImagePickerController()
    let storageRef = FIRStorage.storage().reference()
    @IBOutlet weak var imageUploadOut: UIButton!
    
    
    
    @IBAction func createEvent(_ sender: Any) {
        
        
        //trim whitespace to prevent blank fields
        hostNameOut.text =  hostNameOut.text?.trimmingCharacters(in: .whitespaces)
        eventNameOut.text =  eventNameOut.text?.trimmingCharacters(in: .whitespaces)
        locationOut.text =  locationOut.text?.trimmingCharacters(in: .whitespaces)
        priceOut.text =  priceOut.text?.trimmingCharacters(in: .whitespaces)
        numTixOut.text =  numTixOut.text?.trimmingCharacters(in: .whitespaces)
        
        //check for user input
        if ((hostNameOut.text?.isEmpty)!
            || (eventNameOut.text?.isEmpty)!
            || (locationOut.text?.isEmpty)!
            || (priceOut.text?.isEmpty)!
            || (numTixOut.text?.isEmpty)!){
            
            displayPopup("Please fill out all fields")
        }else{
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
                displayPopup("Please enter a valid price")
            }else if (numTix == nil || numTix! < 0){ //check if ticket field is a number
                
                numTixOut.text = ""
                displayPopup("Please enter a valid number of tickets")

            }else{
                var newEvent = Event(cost: cost!,
                                     ticketsLeft: numTix!,
                                     host: hostName!,
                                     name: eventName!,
                                     location: location!,
                                     eventDate: date,
                                     description: description!,
                                     url: "turnstyle.com")
            
                let EVENTS_REF = Globals.FIREBASE_REF?.child("events")
                    
                let newEventEntry = EVENTS_REF?.childByAutoId()
            
                newEvent.setId(id: newEventEntry!.key)
            
                newEventEntry?.setValue(newEvent.toAnyObject())
                    
                    
                //upload pictures to Firebase Storage
                let eventPictureRef = storageRef.child("eventpictures/" + (newEventEntry?.key)!)
                eventPictureRef.put(imageData, metadata: nil)
            }
            //return to previous view
            navigationController?.popViewController(animated: true)
        }
    }
    
    //Code for pulling up image picker and selecting image
    @IBAction func uploadImage(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageOut.image = selectedImage
        imageData = UIImagePNGRepresentation(selectedImage)!
        dismiss(animated: true, completion: nil)
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
        imageUploadOut.titleLabel?.font = UIFont(name:"BebasNeue", size:18.0)
    }
    
    private func displayPopup(withMessage: String){
        let popUp = UIAlertController(title: "Invalid Form", message: withMessage, preferredStyle: UIAlertControllerStyle.alert)
        popUp.addAction(UIAlertAction(title: "Okay I'm dumb", style: UIAlertActionStyle.default, handler: nil))
        self.present(popUp, animated: true, completion: nil)
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
    
    
    override func viewDidLoad() {
        //styling
        imagePicker.delegate = self
        styleForm()
        descriptionOut.delegate = self
        let sendButton = UIBarButtonItem(title: "Creat Event", style: UIBarButtonItemStyle.plain, target: self, action:  #selector(createEvent(_:)))
        
        self.navigationItem.rightBarButtonItem = sendButton
        //
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
