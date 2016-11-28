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
    var eventTime : Date //Date object stores date and time, to use for time simply ignore date
    
    //constructor for Event from known Event details
    init(cost: Double, ticketsLeft: Int, host: String, name: String, location: String, eventDate: Date, description: String, url: String, eventTime: Date){
        
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
        self.eventTime = eventTime
    }
    
    //constructor for Events from FIRDataSnapshot (reconstruct Firebase data into Event struct)
    init(snapshot: FIRDataSnapshot){
        //TODO: FIX ALL DATES FOR THE LOVE OF GOD
        self.eventId = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        self.ticketCost = snapshotValue["ticketCost"] as! Double
        self.ticketsLeft = snapshotValue["ticketsLeft"] as! Int
        self.host = snapshotValue["host"] as! String
        self.name = snapshotValue["name"] as! String
        self.location = snapshotValue["location"] as! String
        //        self.eventDate = snapshotValue["eventDate"] as! Date
        self.eventDate = Date()
        self.description = snapshotValue["description"] as! String
        self.url = snapshotValue["url"] as! String
        //        self.createdDate = snapshotValue["createdDate"] as! Date
        self.createdDate = Date()
        //        self.eventTime = snapshotValue["eventTime"] as! Date
        self.eventTime = Date()
        
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
            "eventTime" : eventTime.description
        ]
    }
    
    
    
    func getName() -> String {
        return self.name
    }
    
    
    
    
}
