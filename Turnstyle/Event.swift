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
    
    var eventID : String
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
    
    init(cost: Double, ticketsLeft: Int, host: String, name: String, location: String, eventDate: Date, description: String, url: String, eventTime: Date){
        self.eventID = "0" //fix
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

    func toAnyObject() -> Any {
        return [
            "eventId": eventID,
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
    
    //FIX ALL DATES FOR THE LOVE OF GOD
    init(snapshot: FIRDataSnapshot){
        self.eventID = snapshot.key
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
}
