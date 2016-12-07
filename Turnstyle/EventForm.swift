//
//  EventForm.swift
//  Turnstyle
//
//  Copyright © 2016 6164 Productions. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class EventForm: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    var parentView: EventsViewController?
    var pickImage = false
    let imagePicker = UIImagePickerController()
    let storageRef = Globals.STORAGE_REF
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
            
            displayPopup(withMessage: "Please fill out all fields")
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
                displayPopup(withMessage: "Please enter a valid price")
            }else if (numTix == nil || numTix! < 0){ //check if ticket field is a number
                
                numTixOut.text = ""
                displayPopup(withMessage: "Please enter a valid number of tickets")

            }else{
                
                var newEvent = Event(cost: cost!,
                                     ticketsLeft: numTix!,
                                     host: hostName!,
                                     name: eventName!,
                                     location: location!,
                                     eventDate: date,
                                     description: description!,
                                     url: "mikeclimbs.rocks/tickets?")
            
                let EVENTS_REF = Globals.FIREBASE_REF?.child("events")
                    
                let newEventEntry = EVENTS_REF?.childByAutoId()
            
                newEvent.setId(id: newEventEntry!.key)
                
                newEvent.url += "\((newEventEntry?.key)!)"
            
                newEventEntry?.setValue(newEvent.toAnyObject())
                parentView?.loading = newEventEntry?.key
                
                //upload pictures to Firebase Storage
                if(pickImage == true){
                    let eventPictureRef = storageRef?.child("eventpictures/" + (newEventEntry?.key)!)
                    parentView?.uploadTask = eventPictureRef?.put(imageData, metadata: nil)
                    pickImage = false
                }
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
        pickImage = true
        imageOut.image = selectedImage
        imageData = UIImagePNGRepresentation(selectedImage)!
        dismiss(animated: true, completion: nil)
    }
    
    //Additional styling to form
    func styleForm(){
        hostNameOut.font = UIFont(name:Globals.FONT, size:15.0)
        eventNameOut.font = UIFont(name:Globals.FONT, size:15.0)
        locationOut.font = UIFont(name:Globals.FONT, size:15.0)
        priceOut.font = UIFont(name:Globals.FONT, size:15.0)
        numTixOut.font = UIFont(name:Globals.FONT, size:15.0)
        descriptionOut.text = "Description"
        descriptionOut.textColor = UIColor.lightGray
        descriptionOut.font = UIFont(name:Globals.FONT, size:15.0)
        imageUploadOut.titleLabel?.font = UIFont(name:Globals.FONT, size:18.0)
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
        hostNameOut.delegate = self
        eventNameOut.delegate = self
        locationOut.delegate = self
        priceOut.delegate = self
        numTixOut.delegate = self
        descriptionOut.delegate = self
        
        let sendButton = UIBarButtonItem(title: "Creat Event", style: UIBarButtonItemStyle.plain, target: self, action:  #selector(createEvent(_:)))
        
        self.navigationItem.rightBarButtonItem = sendButton
        self.addDoneButtonOnNumpad()
        super.viewDidLoad()
        
    }
    
    func addDoneButtonOnNumpad() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(EventForm.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.priceOut.inputAccessoryView = doneToolbar
        self.numTixOut.inputAccessoryView = doneToolbar
        self.descriptionOut.inputAccessoryView = doneToolbar
    }
    
    
    //function for done button on numpads
    @objc private func doneButtonAction() {
        self.priceOut.resignFirstResponder()
        self.numTixOut.resignFirstResponder()
        self.descriptionOut.resignFirstResponder()
    }
    
    //called when 'return' key pressed. return false to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
