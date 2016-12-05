//
//  Event.swift
//  Turnstyle
//
//  Created by Fede Rozenberg on 11/13/16.
//  Copyright © 2016 6164 Productions. All rights reserved.
//

import Foundation
import Firebase

struct Event{
    
    var eventId : String
    var ticketCost : Double
    var ticketsLeft : Int
    
    var host : String
    var name : String
    var location : String
    var eventDate : Date
    var description : String
    var url : String
    var createdDate : Date
    var hostId : String
    var attendeeList : [String]
    
    //constructor for Event from known Event details
    //for entry into Firebase
    init(cost: Double, ticketsLeft: Int, host: String, name: String, location: String, eventDate: Date, description: String, url: String){
        
        self.eventId = "0" //this is later set in setId, after a new Firebase entry is created by autoChildId
        self.ticketCost = cost
        self.ticketsLeft = ticketsLeft
        self.host = host
        self.name = name
        self.location = location
        self.eventDate = eventDate
        self.description = description
        self.url = url
        self.createdDate = Date()
        self.hostId = Globals.USERID
        self.attendeeList = [Globals.USERID]
    }
    
    //constructor for Events from FIRDataSnapshot (reconstruct Firebase data into Event struct)
    init(snapshot: FIRDataSnapshot){
        self.eventId = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        self.ticketCost = snapshotValue["ticketCost"] as! Double
        self.ticketsLeft = snapshotValue["ticketsLeft"] as! Int
        self.host = snapshotValue["host"] as! String
        self.name = snapshotValue["name"] as! String
        self.location = snapshotValue["location"] as! String
        
        self.description = snapshotValue["description"] as! String
        self.url = snapshotValue["url"] as! String
        
        
        let DATE_FORMATTER = DateFormatter()
        DATE_FORMATTER.dateStyle = DateFormatter.Style.short
        DATE_FORMATTER.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        
        let eventDateString = snapshotValue["eventDate"] as! String

        
        self.eventDate = DATE_FORMATTER.date(from: eventDateString)!
        

        let createdDateString = snapshotValue["createdDate"] as! String
        self.createdDate = DATE_FORMATTER.date(from: createdDateString)!
        
        self.hostId = snapshotValue["hostId"] as! String
        self.attendeeList = snapshotValue["attendeeList"] as! [String]
    }
    
    mutating func setId(id: String){
        self.eventId = id
    }
    
    //converts Event to map for Firebase entry
    func toAnyObject() -> Any {
        return [
            "eventId": eventId,
            "ticketCost" : ticketCost,
            "ticketsLeft" : ticketsLeft,
            "host" : host,
            "name": name,
            "location" : location,
            "eventDate" : eventDate.description,
            "description" : description,
            "url" : url,
            "createdDate" : createdDate.description,
            "hostId" : hostId,
            "attendeeList" : attendeeList
        ]
    }
    
    
    func getName() -> String {
        return self.name
    }
    
    
    
    
}
